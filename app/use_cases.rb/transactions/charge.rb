# frozen_string_literal: true

module Transactions
  class Charge
    include UseCase

    def initialize(args)
      @merchant = args[:merchant]
      @amount = args[:amount].to_f if args[:amount].present?
      @customer_email = args[:customer_email]
      @customer_phone = args[:customer_phone]
    end

    def perform
      return unless create_authorize_transaction

      create_charge_transaction
    end

    def charge_transaction_id
      return @charge.id if success? && @charge.present?
    end

    private

    def verify_customer_amount
      @customer = Customer.find_by!(email: @customer_email)
      if @customer&.customer_bank_account&.balance.to_f < @amount
        errors.add(:base, "Not enough money in customer's account")

        return false
      end

      true
    rescue ActiveRecord::RecordNotFound
      errors.add(:base, "No customer exists with email: #{@customer_email}")

      false
    end

    def create_authorize_transaction
      return false unless verify_customer_amount

      ActiveRecord::Base.transaction do
        hold_and_authorize
      end

      true
    rescue StandardError => e
      errors.add(:base, e.message)
      false
    end

    def hold_and_authorize
      @customer.customer_bank_account.update!(balance: (@customer.customer_bank_account.balance - @amount))
      @authorize_transaction = @merchant.merchant_account.transactions.create!(
        type: 'AuthorizeTransaction', amount: @amount, customer_email: @customer_email,
        customer_phone: @customer_phone, status: :approved
      )
    end

    def create_charge_transaction
      @charge = TransactionCreators::Charge.call(@authorize_transaction, @merchant.merchant_account)
    rescue StandardError => e
      errors.add(:base, "Charge error: #{e.message}")

      reverse_transaction
    end

    def reverse_transaction
      TransactionCreators::Reverse.call(@customer, @authorize_transaction)
      errors.add(:base, 'Transaction reversed')
    rescue StandardError => e
      errors.add(:base, "Reversal error: #{e.message}")
    end
  end
end

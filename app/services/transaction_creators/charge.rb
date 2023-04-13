# frozen_string_literal: true

module TransactionCreators
  class Charge < ApplicationService
    def initialize(authorize_transaction, merchant_account)
      @authorize_transaction = authorize_transaction
      @merchant_account = merchant_account
    end

    def call
      ActiveRecord::Base.transaction do
        @merchant_account.update!(total_transaction_sum: merchant_account_charged)
        create_charge_transaction
      end
    end

    private

    def create_charge_transaction
      ChargeTransaction.create!(
        merchant_account_id: @authorize_transaction.merchant_account_id, amount: @authorize_transaction.amount,
        customer_email: @authorize_transaction.customer_email, customer_phone: @authorize_transaction.customer_phone,
        status: :approved, parent_id: @authorize_transaction.id
      )
    end

    def merchant_account_charged
      @merchant_account.total_transaction_sum + @authorize_transaction.amount
    end
  end
end

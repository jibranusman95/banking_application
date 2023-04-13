# frozen_string_literal: true

module Transactions
  class Refund
    include UseCase

    def initialize(parent_transaction_id)
      @parent_transaction = Transaction.find(parent_transaction_id)
      @customer = Customer.find_by(email: @parent_transaction.customer_email)
    end

    def perform
      if @parent_transaction.charge_transaction?
        refund_transaction
      else
        errors.add(:base, 'Only charge transaction can be refunded')
      end
    end

    private

    def refund_transaction
      return false if already_refunded? || not_enough_in_merchant_account?

      TransactionCreators::Refund.call(@parent_transaction, @customer)
    end

    def not_enough_in_merchant_account?
      return false if @parent_transaction.merchant_account.total_transaction_sum >= @parent_transaction.amount

      errors.add(:base, "There is not enough money in merchant's account")
    end

    def already_refunded?
      if @parent_transaction.refunded?
        errors.add(:base, 'Charge transaction is already refunded')

        return true
      end

      false
    end
  end
end

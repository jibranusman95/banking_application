# frozen_string_literal: true

module TransactionCreators
  class Refund < ApplicationService
    def initialize(parent_transaction, customer)
      @parent_transaction = parent_transaction
      @customer = customer
    end

    def call
      ActiveRecord::Base.transaction do
        @customer.customer_bank_account.update!(balance: customer_refund_balance)
        @parent_transaction.merchant_account.update!(total_transaction_sum: merchant_amount_refunded)

        create_refund_transaction

        @parent_transaction.update!(status: :refunded)
      end
    end

    private

    def create_refund_transaction
      RefundTransaction.create!(
        merchant_account_id: @parent_transaction.merchant_account_id, amount: @parent_transaction.amount,
        customer_email: @parent_transaction.customer_email, customer_phone: @parent_transaction.customer_phone,
        status: :approved, parent_id: @parent_transaction.id
      )
    end

    def merchant_amount_refunded
      @parent_transaction.merchant_account.total_transaction_sum - @parent_transaction.amount
    end

    def customer_refund_balance
      (@customer.customer_bank_account.balance + @parent_transaction.amount)
    end
  end
end

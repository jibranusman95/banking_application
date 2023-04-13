# frozen_string_literal: true

module TransactionCreators
  class Reverse < ApplicationService
    def initialize(customer, authorize_transaction)
      @authorize_transaction = authorize_transaction
      @customer = customer
    end

    def call
      ActiveRecord::Base.transaction do
        @customer.customer_bank_account.update!(balance: customer_balance_reverse)

        ReversalTransaction.create!(
          merchant_account_id: @authorize_transaction.merchant_account_id, amount: nil,
          customer_email: @authorize_transaction.customer_email, customer_phone: @authorize_transaction.customer_phone,
          status: :approved, parent_id: @authorize_transaction.id
        )

        @authorize_transaction.update!(status: :reversed)
      end
    end

    private

    def customer_balance_reverse
      (@customer.customer_bank_account.balance + @authorize_transaction.amount)
    end
  end
end

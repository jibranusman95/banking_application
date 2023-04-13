# frozen_string_literal: true

module Api
  module V1
    class TransactionsController < ActionController::API
      include Api::V1::TransactionsHelper
      include Api::V1::Authenticated

      def create
        create_charge = Transactions::Charge.perform(merchant: @current_user, **transaction_params.to_h.symbolize_keys)

        if create_charge.success?
          render_success(created_transaction_id: create_charge.charge_transaction_id)
        else
          render_failure(errors: create_charge.errors.full_messages.to_sentence)
        end
      end

      def refund
        refund_charge = Transactions::Refund.perform(params[:transaction_id])

        if refund_charge.success?
          render_success(**{})
        else
          render_failure(errors: refund_charge.errors.full_messages.to_sentence)
        end
      end

      private

      def transaction_params
        params.require(:transaction).permit(:customer_email, :customer_phone, :amount)
      end
    end
  end
end

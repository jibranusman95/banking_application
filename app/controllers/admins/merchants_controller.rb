# frozen_string_literal: true

module Admins
  class MerchantsController < ApplicationController
    before_action :authenticate_user!
    before_action :set_merchant, only: %i[edit update destroy]

    def index
      @merchants = Merchant.all.includes(merchant_account: :transactions)
    end

    def edit; end

    def update
      if @merchant.update(merchant_params)
        redirect_to admins_merchant_path(@merchant), notice: 'Merchant updated successfully'
      else
        redirect_to admins_merchant_path(@merchant), alert: @merchant.errors.full_messages.to_sentence
      end
    end

    def destroy
      if @merchant&.merchant_account&.transactions.present?
        redirect_to(admins_merchants_path, alert: 'Can not destroy merchant with active transactions') and return
      end

      if @merchant.destroy
        redirect_to admins_merchants_path, notice: 'Merchant destroyed successfully'
      else
        redirect_to admins_merchants_path, alert: @merchant.errors.full_messages.to_sentence
      end
    end

    private

    def merchant_params
      params.require(:merchant).permit(merchant_account_attributes: %i[name description status])
    end

    def set_merchant
      @merchant = Merchant.find(params[:id])
    end
  end
end

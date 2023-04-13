# frozen_string_literal: true

module Merchants
  class TransactionsController < ApplicationController
    before_action :authenticate_user!

    def index
      @transactions = TransactionsPresenter.new(current_user.merchant_account.transactions.includes(:merchant_account))
    end
  end
end

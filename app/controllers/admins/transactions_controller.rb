# frozen_string_literal: true

module Admins
  class TransactionsController < ApplicationController
    before_action :authenticate_user!

    def index
      @transactions = TransactionsPresenter.new(Transaction.all.includes(:merchant_account))
    end
  end
end

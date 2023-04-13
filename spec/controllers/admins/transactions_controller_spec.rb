# frozen_string_literal: true

require 'rails_helper'
require './spec/controllers/shared/transaction_controller_attributes'

RSpec.describe Admins::TransactionsController, type: :controller do
  include_context 'with transactions_controller params'

  before do
    sign_in(admin)
  end

  describe '#index' do
    before do
      get :index
    end

    it 'returns all transactions' do
      expect(assigns(:transactions).table_attributes).to eq(
        TransactionsPresenter.new(Transaction.where(id: [transaction1.id, transaction2.id])).table_attributes
      )
    end
  end
end

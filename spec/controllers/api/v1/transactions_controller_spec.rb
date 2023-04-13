# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::TransactionsController, type: :controller do
  let!(:customer) { FactoryBot.create(:customer) }
  let!(:merchant) { FactoryBot.create(:merchant) }
  let!(:token) { described_class.new.encode(user_id: merchant.id) }
  let(:json) { JSON.parse(response.body) }

  describe '#create' do
    before do
      request.headers.merge!('Authorization' => token)
      post :create, params: request_params
    end

    context 'with proper token' do
      let(:request_params) { { transaction: { customer_email: customer.email, customer_phone: '123456', amount: 20 } } }

      it { expect(json['message']).to eq('success') }
      it { expect(json['created_transaction_id']).to eq(ChargeTransaction.last.id) }
    end

    context 'with bad token' do
      let(:token) { 'bad_token' }
      let(:request_params) { { transaction: { customer_email: customer.email, customer_phone: '123456', amount: 20 } } }

      it { expect(json['errors']).to be_present }
    end
  end

  describe '#refund' do
    let(:charge_transaction) { ChargeTransaction.last }

    before do
      request.headers.merge!('Authorization' => token)
      post :create, params: { transaction: { customer_email: customer.email, customer_phone: '123456', amount: 20 } } 
      post :refund, params: request_params
    end

    context 'with proper token' do
      let(:request_params) { { transaction_id: charge_transaction } }
      let(:refund_transaction) { RefundTransaction.last }

      it { expect(json['message']).to eq('success') }
      it { expect(refund_transaction).to be_present }
      it { expect(refund_transaction.parent_id).to eq(charge_transaction.id) }
      it { expect(charge_transaction.reload.status).to eq('refunded') }
    end
  end
end

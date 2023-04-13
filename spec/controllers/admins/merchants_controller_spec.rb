# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Admins::MerchantsController, type: :controller do
  let!(:admin) { FactoryBot.create(:admin) }
  let!(:merchants) do
    (1..2).to_a.map do |index|
      FactoryBot.create(:merchant, email: "merchant#{index}@banking.com", password: 'password1')
    end
  end

  before do
    sign_in(admin)
  end

  describe '#index' do
    let(:request_params) { {} }

    before do
      get :index, params: request_params
    end

    it 'returns merchants' do
      expect(assigns(:merchants).ids).to eq(merchants.map(&:id))
    end
  end

  describe '#edit' do
    let(:request_params) { { id: merchants.first.id } }

    before do
      get :edit, params: request_params
    end

    it 'returns merchant' do
      expect(assigns(:merchant).id).to eq(merchants.first.id)
    end
  end

  describe '#update' do
    let(:request_params) do
      { id: merchants.first.id, merchant: { merchant_account_attributes: { name: 'New name', status: :inactive } } }
    end

    before do
      put :update, params: request_params, format: :json
    end

    it 'updates merchant name' do
      expect(merchants.first.reload.merchant_account.reload.name).to eq('New name')
    end

    it 'updates merchant status' do
      expect(merchants.first.reload.merchant_account.reload.status).to eq('inactive')
    end
  end

  describe '#destroy' do
    let(:request_params) { { id: merchants.first.id } }

    before do
      delete :destroy, params: request_params
    end

    context 'when merchant does not have any transactions' do
      it 'destroys merchant' do
        expect { merchants.first.reload }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context 'when merchant has any transactions' do
      let(:customer) { FactoryBot.create(:customer) }
      let!(:transaction) do
        FactoryBot.create(:authorize_transaction, customer_email: customer.email,
                                                  merchant_account: merchants.last.merchant_account, amount: 20.0)
      end

      before do
        delete :destroy, params: { id: merchants.last.id }
      end

      it 'does not destroy merchant' do
        expect { merchants.last.reload.id }.not_to raise_error
      end

      it { expect(transaction).to be_present }
    end
  end
end

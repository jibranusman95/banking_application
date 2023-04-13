# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::AuthenticationController, type: :controller do
  let!(:merchant) { FactoryBot.create(:merchant) }
  let(:json) { JSON.parse(response.body) }

  describe '#login' do
    before do
      post :login, params: request_params
    end

    context 'with correct params' do
      let(:request_params) { { email: merchant.email, password: 'password' } }

      it { expect(json['token']).to be_present }
    end

    context 'with incorrect params' do
      let(:request_params) { { email: merchant.email, password: 'password11' } }

      it 'returns error' do
        expect(json['error']).to eq('unauthorized')
      end
    end
  end
end

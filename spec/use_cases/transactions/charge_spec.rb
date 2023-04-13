# frozen_string_literal: true

require 'rails_helper'
require './spec/use_cases/transactions/validations'

RSpec.describe Transactions::Charge, type: :use_case do
  let(:customer) { FactoryBot.create(:customer) }
  let(:merchant) { FactoryBot.create(:merchant) }
  let(:charge_args) { { merchant: merchant, amount: 20, customer_email: customer.email } }

  describe '#perform(args)' do
    subject(:use_case) { described_class.perform(charge_args) }

    context 'when transaction is successful' do
      let(:customer_balance) { 980 }
      let(:merchant_balance) { 120 }

      it { expect { use_case }.to change(ChargeTransaction, :count).by(1) }
      it { expect { use_case }.to change(AuthorizeTransaction, :count).by(1) }

      include_examples 'success'
      include_examples 'balance_verification'
    end

    context 'when there is an error during charge' do
      let(:customer_balance) { 1000 }
      let(:merchant_balance) { 100 }

      before do
        allow(ChargeTransaction).to receive(:create!).and_raise(StandardError.new('error'))
      end

      it { expect { use_case }.to change(ReversalTransaction, :count).by(1) }
      it { expect { use_case }.to change(AuthorizeTransaction, :count).by(1) }

      include_examples 'failure'
      include_examples 'balance_verification'

      it { expect(use_case.errors.full_messages).to include('Transaction reversed') }
    end

    context 'when customer does not have money in their account' do
      let(:customer_balance) { 10 }
      let(:merchant_balance) { 100 }

      before do
        customer.customer_bank_account.update!(balance: 10)
      end

      include_examples 'failure'
      include_examples 'balance_verification'

      it { expect(use_case.errors.full_messages).to include("Not enough money in customer's account") }
    end
  end
end

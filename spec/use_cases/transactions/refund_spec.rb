# frozen_string_literal: true

require 'rails_helper'
require './spec/use_cases/transactions/validations'

RSpec.describe Transactions::Refund, type: :use_case do
  let(:customer) { FactoryBot.create(:customer) }
  let(:merchant) { FactoryBot.create(:merchant) }
  let(:authorize_transaction) do
    FactoryBot.create(:authorize_transaction, customer_email: customer.email,
                                              merchant_account_id: merchant.merchant_account.id, amount: 20.0)
  end
  let(:charge_transaction) do
    FactoryBot.create(:charge_transaction, customer_email: customer.email,
                                           merchant_account_id: merchant.merchant_account.id,
                                           amount: 20.0, parent_id: authorize_transaction.id)
  end

  describe '#perform(parent_transaction)' do
    subject(:use_case) { described_class.perform(transaction.id) }

    context 'when parent is charge transaction' do
      let(:transaction) { charge_transaction }
      let(:customer_balance) { 1020 }
      let(:merchant_balance) { 80 }

      it { expect { use_case }.to change(RefundTransaction, :count).by(1) }

      include_examples 'success'
      include_examples 'balance_verification'
    end

    context 'when parent has been refunded already' do
      let(:transaction) { charge_transaction }
      let(:customer_balance) { 1000 }
      let(:merchant_balance) { 100 }

      before do
        transaction.update(status: :refunded)
      end

      it { expect { use_case }.to change(RefundTransaction, :count).by(0) }

      include_examples 'failure'
      include_examples 'balance_verification'

      it { expect(use_case.errors.full_messages).to include('Charge transaction is already refunded') }
    end

    context 'when parent is some other transaction' do
      let(:transaction) { authorize_transaction }
      let(:customer_balance) { 1000 }
      let(:merchant_balance) { 100 }

      it { expect { use_case }.to change(RefundTransaction, :count).by(0) }

      include_examples 'failure'
      include_examples 'balance_verification'

      it { expect(use_case.errors.full_messages).to include('Only charge transaction can be refunded') }
    end
  end
end

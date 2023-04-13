# frozen_string_literal: true

RSpec.shared_examples 'transaction_verification' do
  context 'when referencing parent transaction without approved or refunded status' do
    let(:created_transaction) { FactoryBot.create(transaction_type, **transaction_invalid_attrs) }

    it 'creates in a state of error if parent transaction is not in approved or refunded state' do
      expect(created_transaction.status).to eq('error')
    end
  end

  context 'when referencing parent transaction with approved or refunded status' do
    let(:created_transaction) { FactoryBot.create(transaction_type, **transaction_valid_attrs) }

    it 'creates a normal transaction' do
      expect(created_transaction.status).not_to eq('error')
    end
  end
end

RSpec.shared_examples 'merchant_verification' do
  context 'when creating transaction and merchant is invalid' do
    let(:created_transaction) { FactoryBot.create(transaction_type, **transaction_invalid_attrs).to be_invalid }

    it 'is invalid if merchant is in inactive state' do
      expect do
        created_transaction
      end.to raise_error(ActiveRecord::RecordInvalid, 'Validation failed: Merchant cannot be inactive')
    end
  end

  context 'when creating transaction and merchant is valid' do
    let(:created_transaction) { FactoryBot.create(transaction_type, **transaction_valid_attrs) }

    it 'is valid if merchant is in active state' do
      expect(created_transaction).to be_valid
    end
  end
end

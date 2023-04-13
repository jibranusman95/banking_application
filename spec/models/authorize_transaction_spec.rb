# frozen_string_literal: true

require 'rails_helper'
require './spec/models/shared/type_validation'
require './spec/models/shared/transaction_validation'

RSpec.describe AuthorizeTransaction, type: :model do
  let(:customer) { FactoryBot.create(:customer, email: 'customer@banking.com') }
  let(:merchant) { FactoryBot.create(:merchant) }
  let(:valid_attrs) do
    { customer_email: customer.email, merchant_account_id: merchant.merchant_account.id, amount: 20.0 }
  end
  let(:invalid_classes) { %w[ChargeTransaction ReversalTransaction RefundTransaction] }
  let(:valid_class) { 'AuthorizeTransaction' }

  include_examples 'type_verification'
  it { is_expected.to validate_numericality_of(:amount).is_greater_than_or_equal_to(0) }

  context 'when parent is passed' do
    let(:authorize_transaction) { FactoryBot.create(:authorize_transaction, **valid_attrs) }

    it 'is invalid because authorize transaction has no parent' do
      expect(described_class.create(**valid_attrs, parent_id: authorize_transaction.id)).to be_invalid
    end
  end

  context 'with merchant verification' do
    let(:invalid_merchant) { FactoryBot.create(:merchant, email: 'invalid@banking.com') }
    let(:transaction_valid_attrs) { valid_attrs }
    let(:transaction_invalid_attrs) do
      valid_attrs.except(:merchant_account_id).merge!(merchant_account_id: invalid_merchant.merchant_account.id)
    end
    let(:transaction_type) { :authorize_transaction }

    before do
      invalid_merchant.merchant_account.update!(status: :inactive)
    end

    include_examples 'merchant_verification'
  end

  context 'when parent is not passed' do
    it 'is valid because authorize transaction has no parent' do
      expect(described_class.create(**valid_attrs)).to be_valid
    end
  end
end

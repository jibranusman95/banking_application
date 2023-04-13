# frozen_string_literal: true

require 'rails_helper'
require './spec/models/shared/type_validation'

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

  context 'when parent is not passed' do
    it 'is valid because authorize transaction has no parent' do
      expect(described_class.create(**valid_attrs)).to be_valid
    end
  end
end

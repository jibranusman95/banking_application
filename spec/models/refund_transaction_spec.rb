# frozen_string_literal: true

require 'rails_helper'
require './spec/models/shared/type_validation'
require './spec/models/shared/transaction_validation'

RSpec.describe RefundTransaction, type: :model do
  let(:customer) { FactoryBot.create(:customer, email: 'customer@banking.com') }
  let(:merchant) { FactoryBot.create(:merchant) }
  let(:authorize_attrs) do
    { customer_email: customer.email, merchant_account_id: merchant.merchant_account.id, amount: 20.0 }
  end
  let(:authorize_transaction) { FactoryBot.create(:authorize_transaction, **authorize_attrs) }
  let(:charge_attrs) do
    { customer_email: customer.email, merchant_account_id: merchant.merchant_account.id, amount: 20.0,
      parent_id: authorize_transaction.id }
  end
  let(:charge_transaction) { FactoryBot.create(:charge_transaction, **charge_attrs) }
  let(:valid_attrs) do
    { customer_email: customer.email, merchant_account_id: merchant.merchant_account.id, amount: 20.0,
      parent_id: charge_transaction.id }
  end
  let(:invalid_classes) { %w[ReversalTransaction AuthorizeTransaction ChargeTransaction] }
  let(:valid_class) { 'RefundTransaction' }

  include_examples 'type_verification'
  it { is_expected.to validate_numericality_of(:amount).is_greater_than_or_equal_to(0) }
  it { is_expected.to belong_to(:parent) }

  context 'when parent is authorize transaction' do
    it 'is invalid because refund transaction can only have charge transaction as a parent' do
      expect(described_class.create(**valid_attrs, parent_id: authorize_transaction.id)).to be_invalid
    end
  end

  context 'when parent is charge transaction' do
    it 'is valid because refund transaction can only have charge transaction as a parent' do
      expect(described_class.create(**valid_attrs, parent_id: charge_transaction.id)).to be_valid
    end
  end

  context 'with merchant verification' do
    let(:invalid_merchant) { FactoryBot.create(:merchant, email: 'invalid@banking.com') }
    let(:transaction_valid_attrs) { valid_attrs }
    let(:transaction_invalid_attrs) do
      valid_attrs.except(:merchant_account_id).merge!(merchant_account_id: invalid_merchant.merchant_account.id)
    end
    let(:transaction_type) { :refund_transaction }

    before do
      invalid_merchant.merchant_account.update!(status: :inactive)
    end

    include_examples 'merchant_verification'
  end

  context 'with parent verification' do
    let(:error_transaction) { FactoryBot.create(:charge_transaction, **charge_attrs, status: :error) }
    let(:transaction_valid_attrs) { valid_attrs }
    let(:transaction_invalid_attrs) { valid_attrs.except(:parent_id).merge!(parent_id: error_transaction.id) }
    let(:transaction_type) { :refund_transaction }

    include_examples 'transaction_verification'
  end

  context 'when parent is refund transaction' do
    let(:refund_transaction) { FactoryBot.create(:refund_transaction, **authorize_attrs, parent: charge_transaction) }

    it 'is invalid because refund transaction can only have charge transaction as a parent' do
      expect(described_class.create(**valid_attrs, parent_id: refund_transaction.id)).to be_invalid
    end
  end
end

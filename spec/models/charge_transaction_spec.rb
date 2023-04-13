# frozen_string_literal: true

require 'rails_helper'
require './spec/models/shared/type_validation'

RSpec.describe ChargeTransaction, type: :model do
  let(:customer) { FactoryBot.create(:customer, email: 'customer@banking.com') }
  let(:merchant) { FactoryBot.create(:merchant) }
  let(:authorize_attrs) do
    { customer_email: customer.email, merchant_account_id: merchant.merchant_account.id, amount: 20.0 }
  end
  let(:authorize_transaction) { FactoryBot.create(:authorize_transaction, **authorize_attrs) }
  let(:valid_attrs) do
    { customer_email: customer.email, merchant_account_id: merchant.merchant_account.id, amount: 20.0,
      parent_id: authorize_transaction.id }
  end
  let(:invalid_classes) { %w[ReversalTransaction AuthorizeTransaction RefundTransaction] }
  let(:valid_class) { 'ChargeTransaction' }

  include_examples 'type_verification'
  it { is_expected.to validate_numericality_of(:amount).is_greater_than_or_equal_to(0) }
  it { is_expected.to belong_to(:parent) }

  context 'when parent is authorize transaction' do
    it 'is valid because charge transaction can only have authorize as a parent' do
      expect(described_class.create(**valid_attrs, parent_id: authorize_transaction.id)).to be_valid
    end
  end

  context 'when parent is reversal transaction' do
    let(:reversal_transaction) do
      FactoryBot.create(:reversal_transaction, **authorize_attrs.except(:amount), amount: nil,
                                                                                  parent: authorize_transaction)
    end

    it 'is invalid because charge transaction can only have authorize as a parent' do
      expect(described_class.create(**valid_attrs, parent_id: reversal_transaction.id)).to be_invalid
    end
  end

  context 'when parent is refund transaction' do
    let(:charge_transaction) do
      FactoryBot.create(:charge_transaction, **authorize_attrs, parent: authorize_transaction)
    end
    let(:refund_transaction) { FactoryBot.create(:refund_transaction, **authorize_attrs, parent: charge_transaction) }

    it 'is invalid because charge transaction can only have authorize as a parent' do
      expect(described_class.create(**valid_attrs, parent_id: refund_transaction.id)).to be_invalid
    end
  end
end

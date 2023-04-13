# frozen_string_literal: true

require 'rails_helper'
require './spec/models/shared/type_validation'

RSpec.describe ReversalTransaction, type: :model do
  let(:customer) { FactoryBot.create(:customer, email: 'customer@banking.com') }
  let(:merchant) { FactoryBot.create(:merchant) }
  let(:authorize_attrs) do
    { customer_email: customer.email, merchant_account_id: merchant.merchant_account.id, amount: 20.0 }
  end
  let(:authorize_transaction) { FactoryBot.create(:authorize_transaction, **authorize_attrs) }
  let(:valid_attrs) do
    { customer_email: customer.email, merchant_account_id: merchant.merchant_account.id, amount: nil,
      parent_id: authorize_transaction.id }
  end
  let(:invalid_classes) { %w[ChargeTransaction AuthorizeTransaction RefundTransaction] }
  let(:valid_class) { 'ReversalTransaction' }

  include_examples 'type_verification'
  it { is_expected.to validate_absence_of(:amount) }
  it { is_expected.to belong_to(:parent) }

  context 'when parent is authorize transaction' do
    it 'is valid because reversal transaction can only have authorize as a parent' do
      expect(described_class.create(**valid_attrs)).to be_valid
    end
  end

  context 'when parent is charge transaction' do
    let(:charge_transaction) do
      FactoryBot.create(:charge_transaction, **authorize_attrs, parent: authorize_transaction)
    end

    it 'is valid because reversal transaction can only have authorize transaction as a parent' do
      expect(described_class.create(**valid_attrs, parent_id: charge_transaction.id)).to be_invalid
    end
  end

  context 'when parent is refund transaction' do
    let(:charge_transaction) do
      FactoryBot.create(:charge_transaction, **authorize_attrs, parent: authorize_transaction)
    end
    let(:refund_transaction) { FactoryBot.create(:refund_transaction, **authorize_attrs, parent: charge_transaction) }

    it 'is invalid because reversal transaction can only have authorize as a parent' do
      expect(described_class.create(**valid_attrs, parent_id: refund_transaction.id)).to be_invalid
    end
  end
end

# frozen_string_literal: true

require 'rails_helper'
require './spec/models/shared/email_validation'

RSpec.describe Transaction, type: :model do
  let(:email_column) { :customer_email }

  include_examples 'shared_email_verification'
  it { is_expected.to validate_presence_of(:customer_email) }
  it { is_expected.to define_enum_for(:status).with_values(described_class.statuses.keys.map(&:to_sym)) }
  it { is_expected.to validate_presence_of(:type).with_message('is not included in the list') }
  it { is_expected.to validate_inclusion_of(:type).in_array(described_class::AVAILABLE_TYPES) }
  it { is_expected.not_to allow_value(nil).for(:type) }
  it { is_expected.not_to allow_value('SomeOtherValue').for(:type) }
  it { is_expected.not_to allow_value(described_class.class.to_s).for(:type) }
  it { is_expected.to allow_value('AuthorizeTransaction').for(:type) }
  it { is_expected.to allow_value('RefundTransaction').for(:type) }
  it { is_expected.to allow_value('ReversalTransaction').for(:type) }
  it { is_expected.to allow_value('ChargeTransaction').for(:type) }
  it { is_expected.to have_one(:customer_bank_account) }
  it { is_expected.to belong_to(:merchant_account) }
  it { is_expected.to belong_to(:customer) }
end

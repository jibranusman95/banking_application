# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MerchantAccount, type: :model do
  it { is_expected.to have_many(:transactions) }
  it { is_expected.to belong_to(:merchant) }
  it { is_expected.to validate_numericality_of(:total_transaction_sum).is_greater_than_or_equal_to(0) }
  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_presence_of(:status) }
  it { is_expected.to define_enum_for(:status).with_values(described_class.statuses.keys.map(&:to_sym)) }
end

# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CustomerBankAccount, type: :model do
  it { is_expected.to have_many(:transactions) }
  it { is_expected.to belong_to(:customer) }
  it { is_expected.to validate_numericality_of(:balance).is_greater_than_or_equal_to(0) }
end

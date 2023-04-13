# frozen_string_literal: true

require 'rails_helper'
require './spec/models/shared/type_validation'
require './spec/models/shared/params'

RSpec.describe Customer, type: :model do
  include_context 'with user_params'
  let(:invalid_classes) { %w[Merchant Admin] }
  let(:valid_class) { 'Customer' }

  include_examples 'type_verification'
  it { is_expected.to have_many(:transactions) }
  it { is_expected.to have_one(:customer_bank_account) }
end

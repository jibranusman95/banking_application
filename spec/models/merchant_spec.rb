# frozen_string_literal: true

require 'rails_helper'
require './spec/models/shared/type_validation'
require './spec/models/shared/params'

RSpec.describe Merchant, type: :model do
  include_context 'with user_params'
  let(:invalid_classes) { %w[Customer Admin] }
  let(:valid_class) { 'Merchant' }

  include_examples 'type_verification'
  it { is_expected.to have_one(:merchant_account) }
end

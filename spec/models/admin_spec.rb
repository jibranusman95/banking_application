# frozen_string_literal: true

require 'rails_helper'
require './spec/models/shared/type_validation'
require './spec/models/shared/params'

RSpec.describe Admin, type: :model do
  include_context 'with user_params'
  let(:invalid_classes) { %w[Merchant Customer] }
  let(:valid_class) { 'Admin' }

  include_examples 'type_verification'
end

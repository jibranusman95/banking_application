# frozen_string_literal: true

require 'rails_helper'
require './spec/models/shared/email_validation'

RSpec.describe User, type: :model do
  let(:email_column) { :email }

  context 'when database objects are pre requisite for validations' do
    subject { FactoryBot.build(:user, :random, email: 'email@email.com') }

    it { is_expected.to validate_uniqueness_of(:email).case_insensitive }
  end

  include_examples 'shared_email_verification'
  it { is_expected.to validate_presence_of(:type) }
  it { is_expected.to validate_presence_of(:email) }
  it { is_expected.to validate_presence_of(:password) }
  it { is_expected.to validate_inclusion_of(:type).in_array(described_class::AVAILABLE_TYPES) }
  it { is_expected.not_to allow_value(nil).for(:type) }
  it { is_expected.not_to allow_value('SomeOtherValue').for(:type) }
  it { is_expected.not_to allow_value(described_class.class.to_s).for(:type) }
  it { is_expected.to allow_value('Merchant').for(:type) }
  it { is_expected.to allow_value('Customer').for(:type) }
  it { is_expected.to allow_value('Admin').for(:type) }
end

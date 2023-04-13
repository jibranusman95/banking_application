# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Users::ExtractFromCsv, type: :use_case do
  describe '#perform(file_path)' do
    subject(:use_case) { described_class.perform(file_path) }

    let(:file_with_no_errors) { './spec/fixtures/users.csv' }
    let(:file_with_some_errors) { './spec/fixtures/users_some_errors.csv' }
    let(:file_with_all_errors) { './spec/fixtures/users_all_errors.csv' }

    context 'when file has no errors' do
      let(:file_path) { file_with_no_errors }

      it { expect { use_case }.to change(User, :count).by(3) }
      it { expect(use_case).to be_success }
      it { expect(use_case).not_to be_partial_success }
      it { expect(use_case).not_to be_failure }
    end

    context 'when file has some errors' do
      let(:file_path) { file_with_some_errors }
      let(:errors) do
        ['1. Validation failed: Email is invalid, Email is invalid']
      end

      it { expect { use_case }.to change(User, :count).by(2) }
      it { expect(use_case).not_to be_success }
      it { expect(use_case).to be_partial_success }
      it { expect(use_case).not_to be_failure }
      it { expect(use_case.errors.full_messages).to eq(errors) }
    end

    context 'when file has all errors' do
      let(:file_path) { file_with_all_errors }
      let(:errors) do
        ['1. Validation failed: Email is invalid, Email is invalid',
         '2. Validation failed: Email is invalid',
         '3. Validation failed: Email is invalid, Email is invalid']
      end

      it { expect { use_case }.to change(User, :count).by(0) }
      it { expect(use_case).not_to be_success }
      it { expect(use_case).not_to be_partial_success }
      it { expect(use_case).to be_failure }
      it { expect(use_case.errors.full_messages).to eq(errors) }
    end
  end
end

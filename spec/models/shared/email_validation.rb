# frozen_string_literal: true

RSpec.shared_examples 'shared_email_verification' do
  it { is_expected.to allow_value('valid@email.com').for(email_column) }
  it { is_expected.not_to allow_value('invalid@email').for(email_column) }
  it { is_expected.not_to allow_value('invalid @em ail').for(email_column) }
  it { is_expected.not_to allow_value('invalid').for(email_column) }
end

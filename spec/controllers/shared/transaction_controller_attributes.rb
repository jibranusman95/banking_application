# frozen_string_literal: true

RSpec.configure do |rspec|
  rspec.shared_context_metadata_behavior = :apply_to_host_groups
end

RSpec.shared_context 'with transactions_controller params', shared_context: :metadata do
  let(:customer) { FactoryBot.create(:customer) }
  let(:admin) { FactoryBot.create(:admin) }
  let(:merchant1) { FactoryBot.create(:merchant) }
  let(:merchant2) { FactoryBot.create(:merchant, email: 'merchant2@banking.com') }
  let!(:transaction1) do
    FactoryBot.create(:authorize_transaction, customer_email: customer.email,
                                              merchant_account: merchant1.merchant_account, amount: 20.0)
  end

  let!(:transaction2) do
    FactoryBot.create(:authorize_transaction, customer_email: customer.email,
                                              merchant_account: merchant2.merchant_account, amount: 20.0)
  end
end

RSpec.configure do |rspec|
  rspec.include_context 'with transactions_controller params', include_shared: true
end

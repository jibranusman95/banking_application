# frozen_string_literal: true

FactoryBot.define do
  factory :merchant do
    email { 'merchant@banking.com' }
    password { 'password' }
    after(:create) do |merchant|
      FactoryBot.create(:merchant_account, merchant: merchant, total_transaction_sum: 100)
    end
  end
end

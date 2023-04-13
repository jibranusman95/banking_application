# frozen_string_literal: true

FactoryBot.define do
  factory :customer do
    email { 'customer@banking.com' }
    password { 'password' }
    after(:create) do |customer|
      customer.customer_bank_account.destroy
      FactoryBot.create(:customer_bank_account, customer: customer, balance: 1000.0)
    end
  end
end

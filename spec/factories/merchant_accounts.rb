# frozen_string_literal: true

FactoryBot.define do
  factory :merchant_account do
    name { 'Acccount name' }
    status { :active }
    total_transaction_sum { 0 }
  end
end

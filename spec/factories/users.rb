# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    password { 'password' }

    trait :admin do
      type { 'Admin' }
    end

    trait :customer do
      type { 'Customer' }
    end

    trait :merchant do
      type { 'Merchant' }
    end

    trait :random do
      type { %w[Admin Merchant Customer].sample }
    end
  end
end

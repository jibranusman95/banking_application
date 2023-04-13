# frozen_string_literal: true

FactoryBot.define do
  factory :admin do
    email { 'admin@banking.com' }
    password { 'password' }
  end
end

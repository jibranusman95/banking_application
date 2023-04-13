# frozen_string_literal: true

FactoryBot.define do
  factory :charge_transaction do
    status { :approved }
  end
end

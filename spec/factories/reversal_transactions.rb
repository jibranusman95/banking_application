# frozen_string_literal: true

FactoryBot.define do
  factory :reversal_transaction do
    status { :approved }
  end
end

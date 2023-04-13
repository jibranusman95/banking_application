# frozen_string_literal: true

FactoryBot.define do
  factory :refund_transaction do
    status { :approved }
  end
end

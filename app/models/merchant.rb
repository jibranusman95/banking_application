# frozen_string_literal: true

class Merchant < User
  has_one :merchant_account, dependent: :destroy
  accepts_nested_attributes_for :merchant_account, reject_if: :all_blank
end

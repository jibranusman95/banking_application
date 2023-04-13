# frozen_string_literal: true

class MerchantAccount < ApplicationRecord
  belongs_to :merchant
  has_many :transactions, dependent: :destroy

  validates :name, :status, presence: true
  validates :total_transaction_sum, numericality: { greater_than_or_equal_to: 0 }

  enum status: { active: 0, inactive: 1 }
end

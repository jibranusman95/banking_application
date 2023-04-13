# frozen_string_literal: true

class Transaction < ApplicationRecord
  AVAILABLE_TYPES = %w[ChargeTransaction AuthorizeTransaction ReversalTransaction RefundTransaction].freeze
  include TypeEnumable

  belongs_to :parent, class_name: 'Transaction', optional: true
  belongs_to :merchant_account
  belongs_to :customer, foreign_key: 'customer_email', primary_key: 'email'
  has_one :customer_bank_account, through: :customer

  validates :customer_email, presence: true
  validates :customer_email, format: { with: /\A\S+@.+\.\S+\z/ }
  validates_with TransactionCustomValidator

  enum status: { approved: 0, reversed: 1, refunded: 2, error: 3 }

  AVAILABLE_TYPES.each do |available_type|
    scope available_type.split(/(?=[A-Z])/).first.downcase.to_s, -> { where(type: available_type) }
  end
end

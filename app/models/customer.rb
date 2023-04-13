# frozen_string_literal: true

class Customer < User
  has_one :customer_bank_account, dependent: :destroy
  has_many :transactions, primary_key: 'email', foreign_key: 'customer_email'

  before_create :build_customer_bank_account
end

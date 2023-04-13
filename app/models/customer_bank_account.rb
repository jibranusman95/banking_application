# frozen_string_literal: true

class CustomerBankAccount < ApplicationRecord
  belongs_to :customer
  has_many :transactions, through: :customer

  validates :balance, numericality: { greater_than_or_equal_to: 0 }
end

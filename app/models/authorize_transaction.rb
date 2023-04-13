# frozen_string_literal: true

class AuthorizeTransaction < Transaction
  validates :amount, numericality: { greater_than_or_equal_to: 0 }
  validates_with Transactions::ParentAbsentValidator
end

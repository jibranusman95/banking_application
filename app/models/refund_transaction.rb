# frozen_string_literal: true

class RefundTransaction < Transaction
  belongs_to :parent, class_name: 'Transaction'
  validates :amount, numericality: { greater_than_or_equal_to: 0 }
  validates_with Transactions::ParentChargeValidator
end

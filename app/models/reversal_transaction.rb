# frozen_string_literal: true

class ReversalTransaction < Transaction
  belongs_to :parent, class_name: 'Transaction'
  validates :amount, absence: true
  validates_with Transactions::ParentAuthorizeValidator
end

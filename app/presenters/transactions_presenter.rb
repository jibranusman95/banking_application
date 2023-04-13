# frozen_string_literal: true

class TransactionsPresenter
  def initialize(transactions)
    @transactions = transactions
  end

  def table_attributes
    @transactions.map do |transaction|
      {
        'ID' => transaction.id, 'Type' => transaction.type, 'Amount' => transaction.amount.to_s,
        'Status' => transaction.status&.capitalize.to_s, 'Customer Email' => transaction.customer_email,
        'Customer Phone' => transaction.customer_phone.to_s, 'Merchant Name' => transaction.merchant_account.name,
        'Parent ID' => transaction.parent_id.to_s
      }
    end
  end

  def table_headings
    ['ID', 'Type', 'Amount', 'Status', 'Customer Email', 'Customer Phone', 'Merchant Name', 'Parent ID']
  end
end

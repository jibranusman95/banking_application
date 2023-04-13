# frozen_string_literal: true

class CreateCustomerBankAccounts < ActiveRecord::Migration[7.0]
  def change
    create_table :customer_bank_accounts do |t|
      t.float :balance, default: 0
      t.belongs_to :customer

      t.timestamps
    end
  end
end

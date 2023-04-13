# frozen_string_literal: true

class CreateMerchantAccounts < ActiveRecord::Migration[7.0]
  def change
    create_table :merchant_accounts do |t|
      t.string :description
      t.float :total_transaction_sum, default: 0
      t.integer :status, default: 0
      t.string  :name, null: false
      t.belongs_to :merchant

      t.timestamps
    end
  end
end

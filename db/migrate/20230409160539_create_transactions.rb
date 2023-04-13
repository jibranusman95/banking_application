# frozen_string_literal: true

class CreateTransactions < ActiveRecord::Migration[7.0]
  def change
    create_table :transactions, id: :uuid do |t|
      t.float :amount, default: 0
      t.integer :status
      t.string :customer_email, null: false
      t.string :customer_phone
      t.string :type, null: false
      t.belongs_to :merchant_account
      t.uuid :parent_id

      t.timestamps
    end

    add_index :transactions, :parent_id
    add_index :transactions, :customer_email
    add_index :transactions, :type
  end
end

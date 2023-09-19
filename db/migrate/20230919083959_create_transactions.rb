class CreateTransactions < ActiveRecord::Migration[7.0]
  def change
    create_table :transactions do |t|
      t.references :user, null: false, foreign_key: { to_table: :users }
      t.references :opposite_user, null: false, foreign_key: { to_table: :users }
      t.references :escrow_account, foreign_key: { to_table: :escrow_accounts }
      t.decimal :amount
      t.integer :status, null: false, default: 0
      t.integer :role, null: false, default: 0

      t.timestamps
    end
  end
end

class CreateEscrowAccounts < ActiveRecord::Migration[7.0]
  def change
    create_table :escrow_accounts do |t|
      t.decimal :balance

      t.timestamps
    end
  end
end

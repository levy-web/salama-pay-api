class CreateMpesaTransactions < ActiveRecord::Migration[7.0]
  def change
    create_table :mpesa_transactions do |t|
      t.string :checkout_request_id
      t.string :status
      t.decimal :amount

      t.timestamps
    end
  end
end

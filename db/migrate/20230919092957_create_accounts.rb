class CreateAccounts < ActiveRecord::Migration[7.0]
  def change
    create_table :accounts do |t|
      t.references :user, null: false, foreign_key: true, unique: true # Add unique constraint
      t.decimal :balance

      t.timestamps
    end
  end
end

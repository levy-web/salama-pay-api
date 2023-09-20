class CreateHeldFunds < ActiveRecord::Migration[7.0]
  def change
    create_table :held_funds do |t|
      t.decimal :amount
      t.references :user, null: false, foreign_key: true, unique: true

      t.timestamps
    end
  end
end

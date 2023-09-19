class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :firstName
      t.string :middleName
      t.string :surname
      t.string :email
      t.string :password_digest
      t.text :address
      t.string :phone

      t.timestamps
    end
  end
end

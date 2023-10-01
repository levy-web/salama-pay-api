class CreateEmails < ActiveRecord::Migration[7.0]
  def change
    create_table :emails do |t|
      t.string :transaction_id
      t.text :issue_details
      t.text :dispute_details

      t.timestamps
    end
  end
end

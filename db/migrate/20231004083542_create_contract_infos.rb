class CreateContractInfos < ActiveRecord::Migration[7.0]
  def change
    create_table :contract_infos do |t|

      t.text :payment_terms
      t.text :governing_law
      t.text :salama_terms
      t.text :dispute_resolution
      t.text :termination
      t.text :agreement
      t.boolean :accepted
      t.string :seller_name
      t.string :seller_email
      t.string :buyer_name
      t.string :buyer_email
      t.references :transaction, foreign_key: true

      t.timestamps
    end
  end
end

class AddProductInfoToContractInfos < ActiveRecord::Migration[7.0]
  def change
    add_column :contract_infos, :product_name, :string
    add_column :contract_infos, :product_price, :decimal
  end
end

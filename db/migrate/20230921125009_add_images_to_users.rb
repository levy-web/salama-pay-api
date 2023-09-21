class AddImagesToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :id_front_url, :string
    add_column :users, :id_back_url, :string
    add_column :users, :profile_pic_url, :string
  end
end

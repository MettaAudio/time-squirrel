class AddHarvestToUser < ActiveRecord::Migration
  def change
    add_column :users, :harvest_subdomain, :string
    add_column :users, :harvest_username, :string
    add_column :users, :harvest_password, :string
  end
end

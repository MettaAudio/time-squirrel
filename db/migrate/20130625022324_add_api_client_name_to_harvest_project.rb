class AddApiClientNameToHarvestProject < ActiveRecord::Migration
  def change
    add_column :harvest_projects, :api_client_name, :string
  end
end

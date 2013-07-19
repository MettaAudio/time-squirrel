class CreateHarvestProjects < ActiveRecord::Migration
  def change
    create_table :harvest_projects do |t|
      t.integer :project_id
      t.string :api_project_name
      t.integer :api_project_id

      t.timestamps
    end
  end
end

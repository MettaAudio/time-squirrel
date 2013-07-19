class CreateHarvestTasks < ActiveRecord::Migration
  def change
    create_table :harvest_tasks do |t|
      t.integer :harvest_project_id
      t.string :api_task_name
      t.integer :api_task_id

      t.timestamps
    end
  end
end

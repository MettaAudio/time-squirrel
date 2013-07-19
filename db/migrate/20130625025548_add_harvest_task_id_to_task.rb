class AddHarvestTaskIdToTask < ActiveRecord::Migration
  def change
    add_column :tasks, :harvest_task_id, :integer
  end
end

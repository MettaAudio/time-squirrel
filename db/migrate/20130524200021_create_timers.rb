class CreateTimers < ActiveRecord::Migration
  def change
    create_table :timers do |t|
      t.integer :task_id
      t.datetime :start_time
      t.datetime :end_time

      t.timestamps
    end
  end
end

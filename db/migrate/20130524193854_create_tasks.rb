class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.string :issue_id
      t.string :summary

      t.timestamps
    end
  end
end

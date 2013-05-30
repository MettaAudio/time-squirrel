class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.string :code
      t.string :title

      t.timestamps
    end
    add_column :tasks, :project_id, :integer
  end
end

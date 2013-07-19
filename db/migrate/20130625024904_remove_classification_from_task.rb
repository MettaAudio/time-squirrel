class RemoveClassificationFromTask < ActiveRecord::Migration
  def up
    remove_column :tasks, :classification
  end

  def down
    add_column :tasks, :classification, :string
  end
end

class AddClassificationToTask < ActiveRecord::Migration
  def change
    add_column :tasks, :classification, :string, :default => 'Development'
  end
end

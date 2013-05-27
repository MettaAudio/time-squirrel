class AddJiraUserIdAndSecretToUser < ActiveRecord::Migration
  def change
    add_column :users, :jira_user_id, :string
    add_column :users, :jira_secret, :string
  end
end

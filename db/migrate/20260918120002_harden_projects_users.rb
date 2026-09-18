class HardenProjectsUsers < ActiveRecord::Migration[8.0]
  def change
    add_foreign_key :projects_users, :projects
    add_foreign_key :projects_users, :users
    add_index :projects_users, [ :project_id, :user_id ], unique: true, name: "index_projects_users_unique"
  end
end

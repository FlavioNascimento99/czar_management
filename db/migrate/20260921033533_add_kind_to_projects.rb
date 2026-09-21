class AddKindToProjects < ActiveRecord::Migration[8.1]
  def change
    add_column :projects, :kind, :integer, null: false, default: 0
    add_index :projects, :kind
  end
end

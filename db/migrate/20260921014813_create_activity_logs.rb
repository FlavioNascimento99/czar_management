class CreateActivityLogs < ActiveRecord::Migration[8.1]
  def change
    create_table :activity_logs do |t|
      t.references :project, null: false, foreign_key: true
      t.references :actor, null: false, foreign_key: { to_table: :users }
      t.string :action, null: false
      t.string :trackable_type
      t.integer :trackable_id

      t.timestamps
    end
    add_index :activity_logs, [ :project_id, :created_at ]
    add_index :activity_logs, [ :trackable_type, :trackable_id ]
  end
end

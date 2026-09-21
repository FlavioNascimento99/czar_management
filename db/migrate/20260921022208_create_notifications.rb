class CreateNotifications < ActiveRecord::Migration[8.1]
  def change
    create_table :notifications do |t|
      t.references :user, null: false, foreign_key: true
      t.references :actor, null: true, foreign_key: { to_table: :users }
      t.string :action, null: false
      t.string :notifiable_type
      t.integer :notifiable_id
      t.datetime :read_at

      t.timestamps
    end
    add_index :notifications, [ :user_id, :read_at ]
    add_index :notifications, [ :notifiable_type, :notifiable_id ]
  end
end

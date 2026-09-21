class CreateSubtasks < ActiveRecord::Migration[8.1]
  def change
    create_table :subtasks do |t|
      t.references :task, null: false, foreign_key: true
      t.string :title, null: false
      t.boolean :done, null: false, default: false
      t.integer :position, null: false, default: 0

      t.timestamps
    end
    add_index :subtasks, [ :task_id, :position ]
  end
end

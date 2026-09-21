class CreateTaskDocs < ActiveRecord::Migration[8.1]
  def change
    create_table :task_docs do |t|
      t.references :task, null: false, foreign_key: true
      t.references :doc, null: false, foreign_key: true

      t.timestamps
    end
    add_index :task_docs, [ :task_id, :doc_id ], unique: true
  end
end

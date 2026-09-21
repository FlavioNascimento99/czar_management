class CreateTags < ActiveRecord::Migration[8.1]
  def change
    create_table :tags do |t|
      t.references :project, null: false, foreign_key: true
      t.string :name, null: false
      t.string :color, null: false, default: "#0d6efd"

      t.timestamps
    end
    add_index :tags, [ :project_id, :name ], unique: true
  end
end

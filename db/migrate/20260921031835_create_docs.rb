class CreateDocs < ActiveRecord::Migration[8.1]
  def change
    create_table :docs do |t|
      t.references :user, null: false, foreign_key: true
      t.references :folder, null: true, foreign_key: true
      t.string :title, null: false
      t.text :body, null: false, default: ""

      t.timestamps
    end
    add_index :docs, [ :user_id, :updated_at ]
  end
end

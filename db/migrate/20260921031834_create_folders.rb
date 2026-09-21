class CreateFolders < ActiveRecord::Migration[8.1]
  def change
    create_table :folders do |t|
      t.references :user, null: false, foreign_key: true
      t.references :parent, null: true, foreign_key: { to_table: :folders }
      t.string :name, null: false

      t.timestamps
    end
    add_index :folders, [ :user_id, :parent_id, :name ], unique: true
  end
end

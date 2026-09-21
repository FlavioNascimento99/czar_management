class AddRecurrenceToTasks < ActiveRecord::Migration[8.1]
  def change
    add_column :tasks, :recurrence, :integer, null: false, default: 0
    add_index :tasks, :recurrence
  end
end

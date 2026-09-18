class AddOwnerToProjects < ActiveRecord::Migration[8.0]
  def up
    add_reference :projects, :owner, foreign_key: { to_table: :users }
    Project.reset_column_information
    Project.find_each do |project|
      project.update!(owner: project.users.first) if project.owner.nil? && project.users.any?
    end
  end

  def down
    remove_reference :projects, :owner
  end
end

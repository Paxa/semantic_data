class AddStatusToProjects < ActiveRecord::Migration
  def self.up
    rename_column :projects, :state, :status
  end

  def self.down
    rename_column :projects, :status, :state
  end
end

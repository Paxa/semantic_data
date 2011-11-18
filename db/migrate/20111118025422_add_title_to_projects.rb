class AddTitleToProjects < ActiveRecord::Migration
  def self.up
    rename_column :projects, :name, :title
    add_column :projects, :description, :text
  end

  def self.down
    rename_column :projects, :title, :name
    remove_column :projects, :description
  end
end

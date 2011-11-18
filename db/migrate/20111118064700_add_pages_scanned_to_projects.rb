class AddPagesScannedToProjects < ActiveRecord::Migration
  def self.up
    add_column :projects, :pages_scanned, :integer
  end

  def self.down
    remove_column :projects, :pages_scanned
  end
end

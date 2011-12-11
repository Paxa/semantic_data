class AddPagesToExamples < ActiveRecord::Migration
  def self.up
    add_column :examples, :pages, :text
  end

  def self.down
    remove_column :examples, :pages
  end
end

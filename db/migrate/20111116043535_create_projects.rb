class CreateProjects < ActiveRecord::Migration
  def self.up
    create_table :projects do |t|
      t.string :name
      t.string :url
      t.text :item_types
      t.string :state
      t.string :source_code

      t.timestamps
    end
  end

  def self.down
    drop_table :projects
  end
end

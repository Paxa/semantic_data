class CreateParsings < ActiveRecord::Migration
  def self.up
    create_table :parsings do |t|
      t.string :url
      t.text :result
      t.integer :items_count

      t.timestamps
    end
  end

  def self.down
    drop_table :parsings
  end
end

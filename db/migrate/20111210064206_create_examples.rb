class CreateExamples < ActiveRecord::Migration
  def self.up
    create_table :examples do |t|
      t.string :title
      t.string :link
      t.text :description
      t.text :source_codes
      t.text :itemtypes

      t.timestamps
    end
  end

  def self.down
    drop_table :examples
  end
end

class CreateDetectedSites < ActiveRecord::Migration
  def change
    create_table :detected_sites do |t|
      t.string :url
      t.string :user_ip

      t.timestamps
    end
  end
end

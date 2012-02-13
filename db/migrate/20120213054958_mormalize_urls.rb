class MormalizeUrls < ActiveRecord::Migration
  def up
    Project.all.each do |project|
      project.normalize_url
      project.save if project.url_changed?
    end

    Parsing.all.each do |parsing|
      parsing.normalize_url
      parsing.save if parsing.url_changed?
    end
  end

  def down
  end
end

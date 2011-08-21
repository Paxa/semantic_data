require "pathname"

class Post < ActiveRecord::Base
  # parse files as:
  #   date
  #   title
  #   multiline body
  
  def self.from_file(file)
    file = Pathname.new(file) unless file.is_a?(Pathname)
    link = file.to_s.split("/").last.match(/(.+)\.md/)[1]
    
    record = Post.where(:link => link).first || Post.new(:link => link)
    
    content = file.read
    lines = content.split("\n")
    record.published_at = DateTime.parse(lines.shift)
    record.title = lines.shift
    record.body = RedCloth.new(lines.join("\n")).to_html
    
    puts(record.new_record? ? "Creating" : "Updating" + " post #{record.link}")
    record.save
  end
end

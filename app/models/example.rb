class Example < ActiveRecord::Base
  serialize :itemtypes
  serialize :source_codes
  serialize :pages

  def self.load_from_fs(dir)
    meta = YAML::load(dir.join('info.yml').read)
    source_codes = dir.entries.select {|f| f.to_s.end_with?(".haml") }

    example = where(link: dir.basename.to_s).first || new(link: dir.basename.to_s)

    example.title = meta['title']
    example.itemtypes = meta['itemtypes']
    example.pages = meta['pages']
    example.description = Markuped.render('1.md', meta['description'])
    example.created_at = Time.parse(meta['date'])

    example.source_codes = source_codes.map {|f| (dir + f).to_s.sub(Rails.root.to_s + '/', "") }

    puts((example.new_record? ? "Creating" : "Updating") + " example #{example.link}")
    example.save
    example
  end
end

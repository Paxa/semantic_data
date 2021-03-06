require "linker"

class MidaParser
  def initialize(project, levels = 5)
    @project = project
    @levels = levels
  end

  def parse!
    links = [@project.url]
    @found_urls = [@project.url]
    @pages_scanned = 0

    get_description!

    begin
      @levels.times do |ln|
        new_links = []
        links.each do |link|
          resp = Http.http_request(:get, link)
          next if resp.status >= 400 || resp.headers["Content-Type"][0, 5] != "text/"
          html = resp.body

          @pages_scanned += 1
          new_links.push *extract_links(html, link)
          parse_for_microdata(html, link)

          if @pages_scanned > 0 && @pages_scanned % 100 == 0
            @project.update_attribute(:pages_scanned, @pages_scanned)
          end
        end

        links = new_links
      end
    rescue => e
      puts e.message
      puts e.backtrace
    end

    @found_urls.map {|u| u.sub(@project.url, '/') }.each do |u|
      puts "add '#{u}', changefreq: 'daily'"
    end

    @project.update_attribute(:pages_scanned, @pages_scanned)

    @project.item_types.to_s.split(" ")
  end

  def parse_for_microdata(html, url)
    if html.index("itemtype")
      items = Mida::Document.new(html, url).items
      @project.register_item_types(find_types(items))
    end
  end

  def extract_links(html, url)
    uri = URI::parse(URI.encode(url))
    found_links = Linker.extract(html, url).uniq
    filter_regex = %r{://([^/]*)#{Regexp.escape uri.host}(:#{uri.port})?/}
    found_links.select! {|link| link =~ filter_regex && !@found_urls.include?(link)}
    @found_urls.push(*found_links)

    found_links
  end

  def find_types(items, types = [])
    items.each do |item|
      if item.is_a?(Mida::Item)
        types << item.type
        item.properties.values.each do |values|
          find_types(values, types)
        end
      end
    end

    types.uniq
  end

  def get_description!
    doc = Nokogiri::HTML(Http::get(@project.url))

    @project.title = doc.at_css('title').try(:text) unless @project.title.present?

    unless @project.description.present?
      @project.description = doc.at_css('meta[name=description]').try(:attr, 'content')
    end

    @project.source_code = doc.at_css('a[rel=source_code]').try(:attr, 'href') unless @project.source_code.present?

    @project.save!
  end
end
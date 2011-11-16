require "linker"

class MidaParser
  def initialize(project, levels = 5)
    @project = project
    @levels = levels
  end
  
  def parse!
    links = [@project.url]
    @found_urls = [@project.url]
    
    @levels.times do |ln|
      new_links = []
      links.each do |link|
        html = Http.get(link)
        new_links.push *extract_links(html, link)
        parse_for_microdata(html, link)
      end
      
      links = new_links
    end
    
    @project.item_types.to_s.split(" ")
  end
  
  def parse_for_microdata(html, url)
    if html.index("itemtype")
      items = Mida::Document.new(html, url).items
      @project.register_item_types(find_types(items))
    end
  end
  
  def extract_links(html, url)
    uri = URI::parse(url)
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
end
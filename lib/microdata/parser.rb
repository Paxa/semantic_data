require 'open-uri'

class Microdata::Parser
  def self.parse_page(url)
    parser = self.new(url)
    parser.get_page!
    parser.find_resources!
    parser
  end
  
  attr_reader :resources
  
  def initialize(url)
    @url = url
  end
  
  def get_page!
    @doc = Nokogiri::HTML(open(@url))
  end
  
  def find_resources!
    @resources = []
    @doc.css("[itemtype]").each do |node|
      @resources << Microdata::Resource.new(node)
    end
  end
end
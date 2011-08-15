# class for wrapping one microdata resource definition
class Microdata::Resource
  
  attr_reader :provider
  attr_reader :source_url
  
  def initialize(node)
    @type = node.attributes["itemtype"].value
    @fields = node.css("[itemprop]")
  end
end
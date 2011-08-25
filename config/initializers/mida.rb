class Mida::Document
  attr_reader :doc
end

class Mida::Item
  def get_prop(prop_name)
    @properties[prop_name.to_s]
  end
  
  def get_string_prop(prop_name)
    get_prop(prop_name).map(&:to_s).join(" ")
  end
end

def Mida(itemtype)
  if itemtype.is_a?(Symbol)
    itemtype = "http://schema.org/#{itemtype}"
  end

  Mida::Vocabulary.find(itemtype)
end

require "uri"

module URI
  def to_json
    to_s.to_json
  end
end
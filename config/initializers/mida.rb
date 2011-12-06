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
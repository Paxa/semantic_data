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

class Mida::Itemprop
  def extract_property_value
    element = @element.name
    if non_textcontent_element?(element)
      attribute = NON_TEXTCONTENT_ELEMENTS[element]
      if attribute_node = @element.attribute(attribute)
        url_attribute?(attribute) ? make_absolute_url(attribute_node.value) : attribute_node.value
      end
    else
      @element.inner_html.strip
    end
  end
end

require "uri"

module URI
  def to_json
    to_s.to_json
  end
end
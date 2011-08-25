# this hack looks at active-record object's :html_schema_type field and adds itemscope, itemid and itemtype to element
# example:
#
# %article[post] 
# => <article class="post" itemscope itemtype="http://schema.org/BlogPosting" itemid="1">
#
# %section[Mida(:Blog)]
# => <section itemscope itemtype="http://schema.org/Blog">
#
# %span[:title] Hello
# => <span itemprop="title">Hello</span>

class Haml::Buffer
  
  def parse_object_ref(ref)
    options = {}
    
    ref.each do |obj|
      self.class.merge_attrs(options, process_object_ref(obj))
    end
    
    options
  end
  
  def process_object_ref(obj)
    return {} if !obj
    
    if obj.is_a?(Symbol)
      # symbol => "itemprop" attribute
      return {'itemprop' => obj.to_s}
    elsif obj.kind_of?(Mida::Vocabulary)
      # Mida::Vocabulary => itemprop and itemtype
      return {:itemscope => true, :itemtype => obj.itemtype.source}
    else
      options = {}
      options[:class] = obj.respond_to?(:haml_object_ref) ? obj.haml_object_ref : underscore(obj.class)
      options[:id] = "#{options[:class]}_#{obj.id || 'new'}" if obj.respond_to?(:id)
      
      # my hack for microdata attributes
      if obj.respond_to?(:html_schema_type)
        options[:itemscope] = true
        options[:itemid] = obj.id
        raise "No vocabulary found (#{ref.html_schema_type})" unless Mida::Vocabulary.find(obj.html_schema_type)
        options[:itemtype] = obj.html_schema_type
      end
      
      return options
    end
  end

end
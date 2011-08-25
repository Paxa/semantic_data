#Haml::Template.options[:ugly]         = true
#Haml::Template.options[:attr_wrapper] = '"'

# this hack looks at active-record object's :html_schema_type field and adds itemscope, itemid and itemtype to element
# example:
# %article[post] => <article class="post" itemscope itemtype="http://schema.org/BlogPosting" itemid="1">
class Haml::Buffer
  
  def parse_object_ref(ref)
    p [:rel, ref]
    prefix = ref[1]
    ref = ref[0]
    
    # make itemprop=ref if ref if symbol
    # %span[:title] Hello
    # => <span itemprop="title">Hello</span>
    if ref.is_a?(Symbol)
      return {'itemprop' => ref.to_s}
    end
    
    # Let's make sure the value isn't nil. If it is, return the default Hash.
    return {} if ref.nil?
    class_name =
      if ref.respond_to?(:haml_object_ref)
        ref.haml_object_ref
      else
        underscore(ref.class)
      end
    id = "#{class_name}_#{ref.id || 'new'}"
    if prefix
      class_name = "#{ prefix }_#{ class_name}"
      id = "#{ prefix }_#{ id }"
    end
    
    # my hack for microdata attributes
    options = {'id' => id, 'itemid' => ref.id, 'class' => class_name}
    if ref.respond_to?(:html_schema_type)
      options[:itemscope] = true
      raise "No vocabulary found (#{ref.html_schema_type})" unless Mida::Vocabulary.find(ref.html_schema_type)
      options[:itemtype] = ref.html_schema_type
    end
    
    options
  end

end
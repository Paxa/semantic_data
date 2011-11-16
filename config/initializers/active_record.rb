class ActiveRecord::Base
  def self.html_schema_type(value = nil)
    return @html_schema_type unless value
    
    value = /#{value}/ if value.is_a?(Symbol)
    if value.is_a?(Regexp)
      value = Mida::Vocabulary.vocabularies.find do |vocabulary|
        vocabulary.itemtype.to_s =~ value && vocabulary.itemtype.to_s
      end
    end
    
    @html_schema_type = value
  end
  
  def html_schema_type
    self.class.html_schema_type
  end
end
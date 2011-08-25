class ActiveRecord::Base
  def self.html_schema_type(value = nil)
    return @html_schema_type unless value
    @html_schema_type = value
  end
  
  def html_schema_type
    self.class.html_schema_type
  end
end
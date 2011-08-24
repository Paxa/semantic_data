module Rack
  module Utils # :nodoc:
    
    def universal_build(value, prefix = nil)
      case value.class.to_s
      when Array.to_s
        value.map do |v|
          unless unescape(prefix) =~ /\[\]$/
            prefix = "#{prefix}[]"
          end
          universal_build(v, "#{prefix}")
        end.join("&")
      when Hash.to_s
        value.map do |k, v|
          universal_build(v, prefix ? "#{prefix}[#{escape(k)}]" : escape(k))
        end.join("&")
      when NilClass.to_s
        prefix.to_s
      else
        "#{prefix}=#{escape(value.to_s)}"
      end
    end

    module_function :universal_build
  end
end
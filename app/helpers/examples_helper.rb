module ExamplesHelper
  def example_path(example)
    example = Example.find(example) unless example.is_a?(Example)
    "/examples/#{example.link}"
  end
  
  def raw_code_example_path(example, code)
    example_path(example) + "/raw/#{Pathname.new(code).basename.to_s.sub('.haml', '.html')}"
  end
  
  def richsnippets_url(path)
    url = "http://#{HOST}#{URI::escape path}"
    "http://www.google.com/webmasters/tools/richsnippets?url=#{url}"
  end
  
  def parse_example_code(path, rendered)
    Rails.logger.info ["http://#{HOST}#{path}", rendered]
    
    wrapped = "<html><head></head><body>#{rendered}</body></html>"
    
    doc = Mida::Document.new(wrapped, "http://#{HOST}#{path}")
    doc_hash = doc.items.map do |item|
      item.to_h
    end
    
    pretty_json_format(doc_hash)
  end
end

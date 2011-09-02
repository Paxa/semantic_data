xml.instruct! :xml, :version => "1.0" 
xml.rss :version => "2.0" do
  xml.channel do
    xml.title @blog[:title]
    xml.description @blog[:description]
    xml.link @blog[:link]

    for post in @posts
      xml.item do
        xml.title post[:title]
        xml.description post[:body]
        
        xml.pubDate post[:date].to_time.rfc822
        xml.link post[:url]
        xml.guid post[:url]
      end
    end
  end
end
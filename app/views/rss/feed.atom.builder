atom_feed :language => "en-US" do |feed|
  feed.title @blog[:title]
  feed.updated @blog[:updated_at]
  feed.link @blog[:url]
  feed.subtitle @blog[:description]

  @posts.each do |post|
    feed.entry(post, :id => post[:url], :url => post[:url], :updated => post[:date]) do |entry|

      entry.title post[:title]
      entry.content post[:body], :type => "html"

      entry.author do |author|
        author.name(post[:author] || @blog[:author])
      end
    end
  end
end
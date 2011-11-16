class Project < ActiveRecord::Base
  html_schema_type :WebPage
  
  scope :approved, where(state: 'approved')
  #validates_format_of :url, without: URI::regexp(%w(http https)), message: "url does not looks to be valid url"
  validates_format_of :url, without: /^https?:\/\/(.{4, 100})/, message: "url does not looks to be valid url"
  validates_uniqueness_of :url
  
  def register_item_types(types)
    return if types.empty?
    self.item_types ||= ""
    self.item_types = (item_types.split(" ") + types).uniq.join(" ")
    save
  end
  
end

class Project < ActiveRecord::Base
  html_schema_type :WebPage

  STATUSES = %w{new approved declined}

  scope :approved, where(status: 'approved')

  before_validation :normalize_url

  #validates_format_of :url, without: URI::regexp(%w(http https)), message: "url does not looks to be valid url"
  validates_format_of :url, with: /https?:\/\/.{4,}/, message: "url does not looks to be valid url"
  validates_uniqueness_of :url

  def register_item_types(types)
    return if types.empty?
    self.item_types ||= ""
    self.item_types = (item_types.split(" ") + types).uniq.join(" ")
    save
  end

  def parse
    MidaParser.new(self).parse!
  end

  def run_parser!
    Rails.bg_runner "Project.find(#{self.id}).parse"
  end

  def normalize_url
    self.url = Http.normalize_url(self.url)
  end
end

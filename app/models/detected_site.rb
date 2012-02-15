class DetectedSite < ActiveRecord::Base
  before_validation :normalize_url
  validates_uniqueness_of :url

  def normalize_url
    self.url = Http.normalize_url(self.url)
  end
end

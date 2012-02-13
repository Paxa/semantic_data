class Parsing < ActiveRecord::Base
  before_save :normalize_url
  
  def normalize_url
    self.url = Http.normalize_url(self.url)
  end
end

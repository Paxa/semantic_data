class WelcomeController < ApplicationController
  def index
    @last_requests = Parsing.order(:id).limit(10).all
  end
  
  def articles
    
  end
  
  def offline_tools
    
  end
  
  def external_resources
    
  end
end

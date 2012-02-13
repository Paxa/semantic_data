class WelcomeController < ApplicationController
  def index
    @last_requests = Parsing.order("updated_at desc").limit(10).all
  end

  def history
    @parsings = Parsing.where("items_count > 0").order("updated_at desc").limit(80)
  end

  def articles

  end

  def offline_tools

  end

  def external_resources

  end
end

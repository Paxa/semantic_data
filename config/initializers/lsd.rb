Jsus::Middleware.settings[:cache] = Rails.env.production?
Jsus::Middleware.settings[:compression] = :uglifier
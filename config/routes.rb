SemanticDatas::Application.routes.draw do
  resources :articles do
    collection do
      get :how_google_uses
    end
  end
  
  resources :posts do
    
  end
  
  resources :projects
  
  resources :rss do
    collection do
      get :feed
    end
  end
  
  root :to => "welcome#index"
  
  get "external_resources", :to => "welcome#external_resources"
  
  get "get_items", :to => "parser#get_items"
  get "parser/parse_url", :to => "parser#parse_url"

end

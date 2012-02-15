SemanticDatas::Application.routes.draw do
  resources :articles do
    collection do
      get :how_google_uses
    end
  end

  resources :posts

  match '/examples/:id/raw/:file' => 'examples#raw', :as => :raw_code_example
  resources :examples do
    member do
      get :raw
    end
  end

  resources :projects do
    collection do
      get :admin
      post :detected
    end

    member do
      put :status, to: 'projects#set_status'
      put :run_parser
    end
  end

  resources :rss do
    collection do
      get :feed
    end
  end

  root :to => "welcome#index"

  get "admin" => "welcome#admin"
  get "external_resources", :to => "welcome#external_resources"
  get 'history', to: "welcome#history"
  get 'detected_hosts', to: "welcome#detected_hosts"

  get "get_items", :to => "parser#get_items"
  get "parser/parse_url", :to => "parser#parse_url"
  post "parser/parse_content", :to => "parser#parse_content"

end


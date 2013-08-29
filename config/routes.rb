SiteParser::Application.routes.draw do

  root 'product#index'

  resources :product, :only => [:index, :show, :parse]

  get 'parse' => 'product#parse', :as => 'parse'
  get 'circle_parse' => 'product#circle_parse', :as => 'circle_parse'
  get 'football' => 'product#football', :as => 'football'

end

SiteParser::Application.routes.draw do

  root 'product#index'

  resources :product, :only => [:index, :show, :parse]

  get 'parse' => 'product#parse', :as => 'parse'

end

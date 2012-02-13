ActionController::Routing::Routes.draw do |map|
  map.resources :geo_viewers, :member => { :fullscreen => :get }, :only => [:show]
  map.namespace(:admin) do |admin|
    admin.resources :geo_viewers, :except => [ :index, :destroy]
    admin.resources :pins, :only => [:index, :create, :destroy]    
  end
end
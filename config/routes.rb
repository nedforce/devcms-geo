ActionController::Routing::Routes.draw do |map|
  map.resources :geo_viewers, :only => :show
  map.namespace(:admin) do |admin|
    admin.resources :geo_viewers, :except => [ :index, :destroy ]
  end
end
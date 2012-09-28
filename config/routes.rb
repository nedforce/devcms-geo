Rails.application.routes.draw do
  resources :geo_viewers, :only => [:show] do  
    member do
      get :fullscreen
      get :screenreader
    end  
  end

  resources :pins, :only => [] do
    collection do
      get :highlighted_pin
    end
  end

  namespace :admin do
    resources :geo_viewers, :except => [:index, :destroy]
    resources :pins, :only => [:index, :create, :destroy]
  end

end
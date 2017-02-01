Rails.application.routes.draw do

  resources :bots

  get 'game/index'
  get 'game/custom'
  get 'game/play'

  get '/bots/populate/:id', to: 'bots#populate'

  root 'game#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end

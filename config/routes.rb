Rails.application.routes.draw do
  root 'chats#index'

  resources :users do
    collection do
      put 'sing_in'
      post 'auth_sing_in'
      get 'make_session'
      delete 'logout'
      get 'make_payment'
    end
    member do
    end
  end


get '/auth/facebook/callback', to: "users#facebook"
# get '/make_payment'
  scope module: 'api' do
    namespace :v1 do
      resources :users
    end
  end
  put "sign_up", to: "users#create"
  put "sign_in", to: "users#sing_in"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end

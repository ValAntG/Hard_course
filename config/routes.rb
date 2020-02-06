Rails.application.routes.draw do
  devise_for :users
  resources :questions, shallow: true do
    resources :comments
    resources :answers do
      resources :comments
    end
  end

  root to: 'questions#index'

  mount ActionCable.server => '/cable'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end

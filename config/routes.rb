Rails.application.routes.draw do
  use_doorkeeper
  devise_for :users, controllers: { omniauth_callbacks: 'omniauth_callbacks' }
  resources :questions, shallow: true do
    resources :comments, except: %i[show index]
    resources :answers, except: %i[show index] do
      resources :comments, only: %i[new create]
    end
  end

  namespace :api do
    namespace :v1 do
      resource :profiles do
        get :me, on: :collection
      end
    end
  end

  root to: 'questions#index'

  mount ActionCable.server => '/cable'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end

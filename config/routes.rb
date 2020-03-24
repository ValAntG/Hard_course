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
        get 'me', action: :show, controller: 'profiles'
      end
      resources :questions, only: %i[create show index], shallow: true do
        resources :answers, only: %i[create show index]
      end
    end
  end

  root to: 'questions#index'

  mount ActionCable.server => '/cable'
  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?
end

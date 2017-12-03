Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'audio#index'
  resources :audio do
    member do
      get :question_audio, :result
      post :answer
    end
    collection do
      get :end
    end
  end

  resources :files do
    member do
      get :question, :answer
    end
  end
end

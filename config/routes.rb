Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'audio#index'
  resources :audio do
    member do
      get :question_audio
    end
  end
end

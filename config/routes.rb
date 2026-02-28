Rails.application.routes.draw do
  devise_for :users

  root "pages#home"

  # Rotas aninhadas: meses (só logado); chat dentro do mês

  resources :months do
    resource :chat, only: [:show] do
      resources :messages, only: [:create]
    end
  end


  get "up" => "rails/health#show", as: :rails_health_check
end

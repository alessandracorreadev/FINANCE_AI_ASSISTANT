Rails.application.routes.draw do
  devise_for :users

  root "pages#home"

  # Rotas aninhadas: meses (só logado); chat dentro do mês

  resources :months do
    resources :chats, only: [:new, :create]
  end


  get "up" => "rails/health#show", as: :rails_health_check
end

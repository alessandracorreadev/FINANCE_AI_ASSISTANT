Rails.application.routes.draw do
  devise_for :users, path_names: {
    sign_in: 'signin',
    sign_up: 'signup',
    sign_out: 'signout'
  }

  root "pages#home"

  # Rotas aninhadas: meses (só logado); chat dentro do mês
  authenticate :user do
    resources :months do
      resources :chats, only: [:new, :create]
    end
  end

  get "up" => "rails/health#show", as: :rails_health_check
end

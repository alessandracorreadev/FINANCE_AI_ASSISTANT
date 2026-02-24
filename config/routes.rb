Rails.application.routes.draw do
  devise_for :users, path_names: {
    sign_in: 'signin',
    sign_up: 'signup',
    sign_out: 'signout'
  }

  root "pages#home"

  # Hierarquia: usuário → meses → chats (rotas aninhadas RESTful)
  resources :users, only: [] do
    resources :months do
      resources :chats, only: [:new, :create]
    end
  end

  # Verificação de saúde da aplicação em /up (retorna 200 se subir sem exceções)
  get "up" => "rails/health#show", as: :rails_health_check
end

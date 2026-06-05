Rails.application.routes.draw do
  devise_for :users
  
  # Главная страница - используем WelcomeController
  root 'welcome#index'
  
  # Ресурсы задач
  resources :tasks do
    member do
      patch :toggle_complete
    end
  end
  
  # Админ-панель
  namespace :admin do
    resources :users, only: [:index, :edit, :update, :destroy]
  end
end
Rails.application.routes.draw do
  root 'books#new'

  resources :books
end

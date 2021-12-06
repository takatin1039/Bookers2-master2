Rails.application.routes.draw do

  #mailerのrouting設定
  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?
  devise_for :users
  get 'index' => 'homes#index'
  root 'homes#index'
  get 'home/about', to: 'homes#about'
  resources :users, only: [:show, :edit, :update, :index] do
    get 'follows' => 'relationships#follows'
    get 'followers' => 'relationships#followers'
  end
  resources :relationships, only: [:create, :destroy]
  resources :books, only: [:create, :index, :show, :edit, :update, :destroy] do
  	resource :favorites, only: [:create, :destroy]
  	resource :book_comments, only: [:create, :destroy]
  end

  get 'chat/:id', to: 'chats#show', as: 'chat'
  resources :chats, only: [:create]

  get 'search' => 'search#search'


  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end

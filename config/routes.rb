# frozen_string_literal: true

Rails.application.routes.draw do
  root to: 'top#top'

  namespace :api do
    # API用のルーティングはここに書く
    resources :tasks, :only => [:index,:create,:update,:destroy]
    scope :user do
      resources :admin, :only => [:index,:create,:update,:destroy] 
    end
    get "task/search" => "search#todo_search"
    post "auth/signin" => "auth#signin"
    post "auth/signup" => "auth#signup"
    delete "auth/signout" => "auth#signout"
    get "auth/get_token" => "auth#return_token"
    get "auth/current_user" => "auth#current_user"
  end

  get '*path', to: 'top#top', format: false # getのリクエストをまとめる
end

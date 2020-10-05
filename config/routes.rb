# frozen_string_literal: true

Rails.application.routes.draw do
  root to: 'top#top'

  namespace :api do
    # API用のルーティングはここに書く
    resources :tasks
    get "task/search" => "search#todo_search"
    post "auth/signin" => "auth#signin"
    post "auth/signup" => "auth#signup"
    delete "auth/signout" => "auth#signout"
    post "auth/current_user" => "auth#current_user"
  end

  get '*path', to: 'top#top', format: false # getのリクエストをまとめる
end

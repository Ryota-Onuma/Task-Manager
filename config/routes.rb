# frozen_string_literal: true

Rails.application.routes.draw do
  root to: 'top#top'

  namespace :api do
    # API用のルーティングはここに書く
    resources :tasks
  end

  get '*path', to: 'top#top', format: false # getのリクエストをまとめる
end

Rails.application.routes.draw do
  get 'admin/index'
  get 'users/show'
  get 'users/edit'
  get 'users/signUp'
  get 'users/signIn'
  get 'tasks/index'
  get 'tasks/show'
  get 'tasks/new'
  get 'tasks/edit'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end

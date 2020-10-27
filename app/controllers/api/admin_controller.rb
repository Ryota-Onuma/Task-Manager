class Api::AdminController < Api::ApplicationController
  before_action :authenticate!
  before_action :admin?

  def index
    users = User.preload(:tasks).all
    users_tasks = users.map { |user| { "user": user, "tasks": user.tasks } }
    render json: { users_tasks: users_tasks }
  end

  def create
    User.create!(user_params)
    render json: { message: '新規ユーザー登録完了' }, status: :ok
  end

  def update
    User.find(params[:id]).update!(user_params)
    render json: { message: 'ユーザー更新完了' }, status: :ok
  end

  def destroy
    current_user = User.find_by(token: session[:token])
    if current_user.id == params[:id]
      render json: { message: '自分で自分のアカウントは削除できません' }, status: :unprocessable_entity
    else
      user = User.find(params[:id])
      tasks = user.tasks
      user.destroy!
      tasks.destroy_all
      render json: { message: 'ユーザー、及び関連するタスク削除完了' }, status: :ok
    end
  end

  private

  def admin?
    User.find_by(token: session[:token]).admin
  end

  def user_params
    params.require(:user).permit(:name, :email, :permission, :admin)
  end
end
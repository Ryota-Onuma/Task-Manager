class Api::AdminController < Api::ApplicationController
  before_action :authenticate!
  before_action :admin?

  def index
    users = User.preload(:tasks).all
    tasks = users.tasks
    render json: { users: users, tasks: tasks }
  end

  def create
    user = User.create!(user_params)
    render json: { message: 'success' }, status: :ok
  end

  def update; end

  def destroy; end

  private

  def admin?
    User.find_by(token: session[:token]).admin
  end

  def user_params
    params.require(:user).permit(:name, :email, :password_digest)
  end
end

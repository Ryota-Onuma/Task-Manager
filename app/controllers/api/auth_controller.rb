class Api::AuthController < Api::ApplicationController
  before_action :authenticate!, only: %i[signout current_user]

  def signin
    @user = User.find_by(email: params[:user][:email], password_digest: params[:user][:password])
    if @user
      render json: @user
    else
      render json: { errors: 'メールアドレスまたはパスワードが違います。' }, status: :unauthorized
    end
  end

  def signup
    user = User.new(email: params[:user][:email], password_digest: params[:user][:password_digest], name: params[:user][:name])
    if user.save!
      render json: user
    else
      render json: { errors: user.errors.full_messages }, status: :bad_request
    end
  end

  def signout; end

  def current_user
    current_user = User.find_by(token: request.headers['Authorization'].split[1])
    render json: { current_user: current_user }
  end
end

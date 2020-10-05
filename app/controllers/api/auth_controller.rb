class Api::AuthController < Api::ApplicationController
  before_action :authenticate!, only: %i[signout current_user]

  def signin
    user = User.find_by(email: params[:user][:email], password_digest: params[:user][:password])
    if user
      session[:token] = user.token
      render json: user.token
    else
      render json: { errors: 'メールアドレスまたはパスワードが違います。' }, status: :unauthorized
    end
  end

  def signup
    user = User.new(email: params[:user][:email], password_digest: params[:user][:password_digest], name: params[:user][:name])
    if user.save!
      session[:token] = user.token
      render json: user
    else
      render json: { errors: user.errors.full_messages }, status: :bad_request
    end
  end

  def signout
    if session[:token].clear # sessionを消す
      render json: { message: 'signout成功！！！' }
    else
      render json: { error: 'サインアウトできませんでした。エラーです' }
    end
  end

  def return_token
    token = session[:token].presence || false # tokenがあればそれを返す なかったらfalseを返す
    render json: token
  end

  def current_user
    current_user = session[:token].present? ? User.find_by(token: session[:token]) : false
    render json: current_user
  end
end

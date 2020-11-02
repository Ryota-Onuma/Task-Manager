class Api::ApplicationController < ActionController::API
  include ActionController::HttpAuthentication::Token::ControllerMethods  # ActionController::API には ActionController::HttpAuthentication Module は含まれていないから

  before_action :basic_auth, if: :production?

  rescue_from  ActiveRecord::RecordInvalid, with: :rescue_422_error
  rescue_from  ActiveRecord::RecordNotUnique, with: :rescue_500_error
  rescue_from  ActiveRecord::RecordNotSaved, with: :rescue_422_error
  rescue_from  ActiveRecord::StatementInvalid, with: :rescue_500_error
  rescue_from  ActiveRecord::RecordNotDestroyed, with: :rescue_500_error
  rescue_from  ActiveRecord::RecordNotFound, with: :rescue_404_error

  def authenticate!
    authenticate_token || render_unauthorized
  end

  def authenticate_token
    authenticate_or_request_with_http_token do |token, _options|
      user = User.find_by(token: token)
      return user.present?
    end
  end

  def render_unauthorized
    render json: { message: 'token invalid' }, status: :unauthorized
  end

  private

  def rescue_422_error(error)
    render status: :unprocessable_entity, json: { error: error }
  end

  def rescue_500_error(error)
    render status: :internal_server_error, json: { error: error }
  end

  def rescue_404_error(error)
    render status: :not_found, json: { error: error }
  end

  def production?
    Rails.env.production?
  end

  def basic_auth
    authenticate_or_request_with_http_basic do |username, password|
      username == ENV['BASIC_AUTH_USER'] && password == ENV['BASIC_AUTH_PASSWORD']
    end
  end

  class NoAdminUserError < StandardError
    def initialize(msg = '管理者権限がありません')
      super
    end
  end
end

# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :basic_auth, if: :production?
  protect_from_forgery with: :exception

  rescue_from  ActiveRecord::RecordInvalid, with: :rescue_422_error
  rescue_from  ActiveRecord::RecordNotUnique, with: :rescue_500_error
  rescue_from  ActiveRecord::RecordNotSaved, with: :rescue_422_error
  rescue_from  ActiveRecord::StatementInvalid, with: :rescue_500_error
  rescue_from  ActiveRecord::RecordNotDestroyed, with: :rescue_500_error
  rescue_from  ActiveRecord::RecordNotFound, with: :rescue_404_error

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
end

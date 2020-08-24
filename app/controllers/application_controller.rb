# frozen_string_literal: true

class ApplicationController < ActionController::Base
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
end

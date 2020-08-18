# frozen_string_literal: true

class ApplicationController < ActionController::Base
  rescue_from  ActiveRecord::RecordInvalid, with: :rescue_validation_error
  rescue_from  ActiveRecord::RecordNotUnique, with: :rescue_validation_error
  rescue_from  ActiveRecord::RecordNotSaved, with: :rescue_validation_error
  rescue_from  ActiveRecord::StatementInvalid, with: :rescue_validation_error

  private

  def rescue_validation_error(error)
    render status: :internal_server_error, json: { error: error}
  end
end

# frozen_string_literal: true

class ApplicationController < ActionController::Base
  rescue_from  ActiveRecord::RecordInvalid, with: :rescue_validation_422_error
  rescue_from  ActiveRecord::RecordNotUnique, with: :rescue_validation_500_error
  rescue_from  ActiveRecord::RecordNotSaved, with: :rescue_validation_422_error
  rescue_from  ActiveRecord::StatementInvalid, with: :rescue_validation_500_error
  rescue_from  ActiveRecord::RecordNotDestroyed,with: :rescue_validation_500_error
  rescue_from  ActiveRecord::RecordNotFound, with: :rescue_validation_404_error   

  private

  def rescue_validation_422_error(error)
    render status:422, json: { error: error }
  end
  def rescue_validation_500_error(error)
    render status:500, json: { error: error }
  end
  def rescue_validation_404_error(error)
    render status:404, json: { error: error }
  end
end

class Api::AdminController < ActionController::API
  before_action :authenticate!
  before_action :is_admin?

  def index; end

  private

  def is_admin?
    User.find_by(token: session[:token]).admin
  end
end

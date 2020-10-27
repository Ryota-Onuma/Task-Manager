class Api::AdminController < ActionController::API
  before_action :authenticate!
  before_action :admin?

  def index; end

  def new; end

  def create; end

  def edit; end

  def update; end

  def destroy; end

  private

  def admin?
    User.find_by(token: session[:token]).admin
  end
end

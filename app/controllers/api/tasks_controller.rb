# frozen_string_literal: true

class Api::TasksController < Api::ApplicationController
  before_action :authenticate!
  def index
    returnTasksAndUsersAllData
  end

  def create
    current_user = User.find_by(token: session[:token])
    task = Task.new(task_params)
    task.user_id = current_user.id
    task.save!
    returnTasksAndUsersAllData
  end

  def update
    task = Task.find(params[:id])
    task.update!(task_params)
    returnTasksAndUsersAllData
  end

  def destroy
    task = Task.find(params[:id])
    if task.destroy!
      returnTasksAndUsersAllData
    else
      render json: { message: 'failed' }
    end
  end

  private

  def returnTasksAndUsersAllData
    current_user = User.find_by(token: session[:token])
    tasks = Task.where(user_id: current_user.id).order(created_at: 'DESC') # 新しい順です
    users = User.all
    info = {
      tasks: tasks,
      users: users
    }
    render json: info
  end

  def task_params
    params.require(:inputTask).permit(:id, :user_id, :created_at, :updated_at, :title, :content, :status, :deadline, :important)
  end
end

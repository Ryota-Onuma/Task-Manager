# frozen_string_literal: true

class Api::TasksController < Api::ApplicationController
  before_action :authenticate!
  def index
    returnTasksAndUsersAllData
  end

  def create
    task = Task.new(task_params)
    task.user_id = 1 # まだログイン機能をつけてないので
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
    tasks = Task.all.order(created_at: 'DESC') # 新しい順です
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

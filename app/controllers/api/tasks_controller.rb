# frozen_string_literal: true

class Api::TasksController < ApplicationController
  def index
    returnTasksAndUsersAllData
  end

  def create
    task = Task.new(task_params)
    task.deadline = DateTime.now
    task.user_id = 1 # まだログイン機能をつけてないので
    begin
      returnTasksAndUsersAllData if task.save!
    rescue => error
      render status:500 ,json: { error: error }
    end
    
  end

  def update
    task = Task.find(params[:id])
    begin
    returnTasksAndUsersAllData if task.update!(task_params)
    rescue => error
      render status:500 ,json: { error: error }
    end
  end
  
  def destroy
    task = Task.find(params[:id])
    if task.destroy
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


# frozen_string_literal: true

class Api::TasksController < ApplicationController
  def index
    returnTasksAndUsersAllData
  end

  def create
    task = Task.new(task_params)
                                    task.deadline = DateTime.now
    task.user_id = 1 # まだログイン機能をつけてないので
                                    returnTasksAndUsersAllData if task.save!
  end

  def update
    task = Task.find(params[:id])
    task.title = params[:inputTask][:title]
                                        task.deadline = params[:inputTask][:deadline]
                                        task.content = params[:inputTask][:content]

    task.status = params[:inputTask][:status]
    task.important = params[:inputTask][:important]

    returnTasksAndUsersAllData if task.save!
  end

  private

    def returnTasksAndUsersAllData
      tasks = Task.all.order(created_at: 'DESC') # 新しい順
      users = User.all
      info = {
        tasks: tasks,
        users: users
      }
      render json: info
    end

    def task_params
      params.require(:inputTask).permit(:title, :content, :status, :deadline, :important)
    end
end

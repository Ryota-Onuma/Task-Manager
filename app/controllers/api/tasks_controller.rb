# frozen_string_literal: true

class Api::TasksController < ApplicationController
    def index
        tasks = Task.all
        users = User.all
        info = {
            tasks: tasks,
            users:users
        }
        render :json => info
    end
    def show
        task = Task.find(params[:id])
        user = User.find(task.user_id)
        info = {
            task: task,
            user:user
        }
        render :json => info
    end
    def create
        task = Task.create(task_params)
        

    end
    def update


    end

    private

    def task_params
        params.require(:inputTask).permit(:name, :email, recommend_book: [:user_id, :comment])
    end
end

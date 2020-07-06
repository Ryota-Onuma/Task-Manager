# frozen_string_literal: true

class Api::TasksController < ApplicationController
    def index
        tasks = Task.all
        render :json => tasks
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
end

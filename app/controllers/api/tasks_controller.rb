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
    tag_ids = params[:tags].map(&:to_i)
    tag_ids.each do |tag_id|
      Tagtask.create!(task_id: task.id, tag_id: tag_id)
    end
    returnTasksAndUsersAllData
  end

  def update
    task = Task.preload(:tagtasks).find(params[:id])
    task.update!(task_params)
    sent_tag_ids = params[:tags].map(&:to_i)
    old_tag_ids = task.tagtasks.map { |tagtask| tagtask.tag_id}

    create_targets = sent_tag_ids - old_tag_ids # 更新により誕生したtaskたち
    create_targets.each do |tag_id|
      Tagtask.create!(task_id: task.id, tag_id: tag_id)
    end

    delete_targets = old_tag_ids - sent_tag_ids # 更新により削除が運命づけられたtaskたち
    delete_targets.each do |tag_id|
      Tagtask.find_by(task_id: task.id, tag_id: tag_id).destroy!
    end

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
    tags = Tag.all
    tagtasks = Tagtask.all
    users = User.all
    info = {
      tasks: tasks,
      tags: tags,
      tagtasks: tagtasks,
      users: users
    }
    render json: info
  end

  def task_params
    params.require(:inputTask).permit(:id, :user_id, :created_at, :updated_at, :title, :content, :status, :deadline, :important)
  end
end

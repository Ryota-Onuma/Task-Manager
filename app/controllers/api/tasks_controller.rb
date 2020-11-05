# frozen_string_literal: true

class Api::TasksController < Api::ApplicationController
  before_action :authenticate!
  def index
    returnTasksAndUsersAllData
  end

  def create
    current_user = User.find_by(token: session[:token])
    task = Task.new(task_params)
    tag_ids = params[:tags].map { |x| x.to_i }
    tag_ids.each do |tag_id|
      task.tag.create!(tag_id: tag_id)
    end
    task.user_id = current_user.id
    task.save!
    returnTasksAndUsersAllData
  end

  def update
    task = Task.preload(:tagtasks).find(params[:id])
    sent_tag_ids = params[:tags].map { |x| x.to_i }
    old_tag_ids = task.tagtasks.map { |x| x.tag_id }

    create_targets = sent_tag_ids - old_tag_ids　 # 更新により誕生したtaskたち
    create_targets.each do |tag_id|
      task.tagtask.create!(tag_id: tag_id)
    end

    delete_targets = old_tag_ids - sent_tag_ids # 更新により削除が運命づけられたtaskたち
    delete_targets.each do |tag_id|
      Tagtask.find_by(task_id: task.id, tag_id: tag_id).destroy!
    end
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
    tags = Tag.all
    tagtasks = Tagtasks.all
    users = User.all
    info = {
      tasks: tasks,
      tags: tags,
      users: users
    }
    render json: info
  end

  def task_params
    params.require(:inputTask).permit(:id, :user_id, :created_at, :updated_at, :title, :content, :status, :deadline, :important)
  end
end

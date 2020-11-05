class Api::SearchController < Api::ApplicationController
  before_action :authenticate!
  def todo_search
    @q = Task.ransack(search_params)
    @tasks = @q.result(distinct: true)
    if params[:tag_id].present?
      @tasks.each_with_index do |task, index|
        @tasks = @tasks.delete_at(index) unless task.tagtasks.map { |tagtask| tagtask.tag_id }.include?(params[:tag_id])
      end
    end
    render json: { tasks: @tasks }
  end
end

private
def search_params
  params.require(:q).permit(:title_cont, :status_eq, :important_eq)
end

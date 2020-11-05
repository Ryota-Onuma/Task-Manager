class Api::SearchController < Api::ApplicationController
  before_action :authenticate!
  def todo_search
    @q = Task.joins(:tagtasks).ransack(search_params)
    @tasks = @q.result(distinct: true)
    render json: { tasks: @tasks }
  end
end

private
def search_params
  params.require(:q).permit(:title_cont, :status_eq, :important_eq, :tag_id_eq)
end

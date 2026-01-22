class TasksController < ApplicationController
  # GET /projects/:project_id/tasks
  def index
    project = @current_user.projects.find(params[:project_id])
    render json: project.tasks
  end

  # POST /projects/:project_id/tasks
  def create
    project = @current_user.projects.find(params[:project_id])
    task = project.tasks.create!(
      task_params.merge(status: "pending")
    )
    render json: task, status: :created
  end

  # PATCH /tasks/:id
  def update
    task = Task
      .joins(:project)
      .where(projects: { user_id: @current_user.id })
      .find(params[:id])

    task.update!(task_params)
    render json: task
  end

  private

  def task_params
    params.permit(:title, :status)
  end
end

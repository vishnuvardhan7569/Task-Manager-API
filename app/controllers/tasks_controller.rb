class TasksController < ApplicationController
  def create
    project = @current_user.projects.find(params[:project_id])
    task = project.tasks.create!(
      title: params[:title],
      status: "pending"
    )
    render json: task, status: :created
  end

  def update
    task = Task.joins(:project)
               .where(projects: { user_id: @current_user.id })
               .find(params[:id])

    task.update!(status: params[:status])
    render json: task
  end

  def index
    project = @current_user.projects.find(params[:project_id])
    render json: project.tasks
  end
end


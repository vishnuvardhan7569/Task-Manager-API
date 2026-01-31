class TasksController < ApplicationController
  before_action :set_project
  before_action :set_task, only: [:update, :destroy]

  # GET /projects/:project_id/tasks
  def index
    page = (params[:page] || 1).to_i
    limit = (params[:limit] || 10).to_i

    total_tasks = @project.tasks.count
    tasks = @project.tasks.order(:id).offset((page - 1) * limit).limit(limit)

    render json: {
      tasks: tasks.map { |t| { id: t.id, title: t.title, description: t.description, status: t.status } },
      total_tasks: total_tasks,
      page: page,
      limit: limit
    }
  end

  # POST /projects/:project_id/tasks
  def create
    task = @project.tasks.create!(task_params)
    @project.reload

    total = @project.tasks.count
    completed = @project.tasks.where(status: 'completed').count
    percent = total.positive? ? ((completed.to_f / total) * 100).round : 0

    render json: {
      task: { id: task.id, title: task.title, description: task.description, status: task.status },
      project_summary: { id: @project.id, total_tasks: total, completed_tasks: completed, percent: percent }
    }, status: :created
  end

  # PATCH /projects/:project_id/tasks/:id
  def update
    @task.update!(task_params)

    total = @project.tasks.count
    completed = @project.tasks.where(status: 'completed').count
    percent = total.positive? ? ((completed.to_f / total) * 100).round : 0

    render json: {
      task: { id: @task.id, title: @task.title, description: @task.description, status: @task.status },
      project_summary: { id: @project.id, total_tasks: total, completed_tasks: completed, percent: percent }
    }
  end

  # DELETE /projects/:project_id/tasks/:id
  def destroy
    @task.destroy
    @project.reload

    total = @project.tasks.count
    completed = @project.tasks.where(status: 'completed').count
    percent = total.positive? ? ((completed.to_f / total) * 100).round : 0

    render json: { project_summary: { id: @project.id, total_tasks: total, completed_tasks: completed, percent: percent } }
  end

  private

  def set_project
    @project = @current_user.projects.find(params[:project_id])
  end

  def set_task
    @task = @project.tasks.find(params[:id])
  end

  def task_params
    params.permit(:title, :description, :status)
  end
end

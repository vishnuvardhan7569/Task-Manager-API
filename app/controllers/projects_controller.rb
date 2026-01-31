class ProjectsController < ApplicationController
  before_action :set_project, only: [ :show, :update, :destroy ]

  def index
    page = (params[:page] || 1).to_i
    limit = (params[:limit] || 10).to_i

    projects_scope = @current_user.projects
      .left_joins(:tasks)
      .select(
        "projects.*,
         COUNT(tasks.id) AS total_tasks,
         SUM(CASE WHEN tasks.status = 'completed' THEN 1 ELSE 0 END) AS completed_tasks"
      )
      .group("projects.id")

    total_projects = @current_user.projects.count
    projects = projects_scope.offset((page - 1) * limit).limit(limit)

    render json: {
      projects: projects.map do |p|
        total = p.try(:total_tasks).to_i
        completed = p.try(:completed_tasks).to_i
        percent = total.positive? ? ((completed.to_f / total) * 100).round : 0

        {
          id: p.id,
          name: p.name,
          domain: p.domain,
          description: p.description,
          total_tasks: total,
          completed_tasks: completed,
          percent: percent
        }
      end,
      total_projects: total_projects,
      page: page,
      limit: limit
    }
  end

  def show
    total = @project.tasks.count
    completed = @project.tasks.where(status: 'completed').count
    percent = total.positive? ? ((completed.to_f / total) * 100).round : 0

    render json: {
      id: @project.id,
      name: @project.name,
      domain: @project.domain,
      description: @project.description,
      total_tasks: total,
      completed_tasks: completed,
      percent: percent
    }
  end

  def create
    project = @current_user.projects.create!(project_params)

    render json: {
      id: project.id,
      name: project.name,
      domain: project.domain,
      description: project.description,
      total_tasks: 0,
      completed_tasks: 0,
      percent: 0
    }, status: :created
  end

  def update
    @project.update!(project_params)
    total = @project.tasks.count
    completed = @project.tasks.where(status: 'completed').count
    percent = total.positive? ? ((completed.to_f / total) * 100).round : 0

    render json: {
      id: @project.id,
      name: @project.name,
      domain: @project.domain,
      description: @project.description,
      total_tasks: total,
      completed_tasks: completed,
      percent: percent
    }
  end

  def destroy
    @project.destroy
    render json: { project_summary: { total_projects: @current_user.projects.count } }
  end

  private

  def set_project
    @project = @current_user.projects.find(params[:id])
  end

  def project_params
    params.permit(:name, :domain, :description)
  end
end

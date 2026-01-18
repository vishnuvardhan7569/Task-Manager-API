class ProjectsController < ApplicationController
  def index
    render json: @current_user.projects
  end

  def create
    project = @current_user.projects.create!(project_params)
    render json: project, status: :created
  end

  def show
    project = @current_user.projects.find(params[:id])
    render json: project
  end

  private

  def project_params
    params.permit(:name, :description)
  end
end


class ProjectsController < ApplicationController
  before_action :set_project, only: :show

  def index
    render json: @current_user.projects
  end

  def create
    project = @current_user.projects.create!(project_params)
    render json: project, status: :created
  end

  def show
    render json: @project
  end

  private

  def set_project
    @project = @current_user.projects.find(params[:id])
  end

  def project_params
    params.permit(:name, :description)
  end
end

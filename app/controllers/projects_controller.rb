class ProjectsController < ApplicationController
  before_filter :find_project
  before_filter :authenticate_with_http!, :only => [:admin, :edit, :update, :destroy, :set_status, :run_parser]
  
  def index
    @projects = Project.approved.all
  end
  
  def new
    @project = Project.new
  end
  
  def create
    @project = Project.new(params[:project])
    @project.status = "new"
    
    if @project.save
      redirect_to :projects, notice: "Project suggested, thank you!"
    else
      render :new
    end
  end
  
  def update
    if @project.update_attributes(params[:project])
      redirect_to admin_projects_path, notice: "Project upgraded"
    else
      flash[:warning] = "Errors happen"
      render :edit
    end
  end
  
  def destroy
    @projects.destroy
    redirect_to :projects, notice: "Destroyed!"
  end
  
  def set_status
    @project.update_attributes!(status: params[:new])
    redirect_to admin_projects_path, notice: "Project upgraded"
  end
  
  def run_parser
    Rails.bg_runner "Project.find(#{@project.id}).parse"
    redirect_to admin_projects_path, notice: "Parsing started"
  end
  
  def admin
    @projects = Project.all
  end
  
  def find_project
    @project = Project.find(params[:id]) if params[:id]
  end
end

class ProjectsController < ApplicationController
  def index
    @projects = Project.approved.all
    
  end
  
  def new
    @project = Project.new
  end
  
  def create
    @project = Project.new(params[:project])
    @project.state = "new"
    
    if @project.save
      redirect_to :projects, notice: "Project suggested, thank you!"
    else
      render :new
    end
  end
end

class ProjectsController < ApplicationController
    before_action :signed_in_user

  def edit
    @project = Project.find(params[:id])
  end
  
  def show
     @projects = Projects.all.by_name
    
  end

  def new
      @project = Project.new
     
  end
    
  def create
        
    current_group = current_user.group

    @project = current_group.projects.build(project_params)
    if @project.save
      flash[:success] = "A new Project was created!"
      redirect_to current_user
    else
      render 'projects/new'
    end
  end

  
  def update
  end

  def destroy
  end

  def correct_group
      @project = current_group.projects.find_by(id: params[:id])
      redirect_to root_url if @project.nil?
  end
  
  def left_nav
    current_group = current_user.group
    @abv = "proba"
  end
  

  private

    def project_params
      params.require(:project).permit(:name,:id,:percent_owned, :group_id)
    end


end



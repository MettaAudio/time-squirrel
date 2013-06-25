class HarvestProjectsController < ApplicationController
  def index
    @harvest_projects = HarvestProject.all
  end

  def edit
    @harvest_project = HarvestProject.find(params[:id])
    @projects = Project.all.collect { |p| [p.title, p.id] }
  end

  def update
    @harvest_project = HarvestProject.find(params[:id])

    if @harvest_project.update_attributes(params[:harvest_project])

      unlinked_project = HarvestProject.without_ts_project
      if unlinked_project.count != 0
        @harvest_project = unlinked_project.first
        redirect_to edit_harvest_project_path(@harvest_project)
      else
        redirect_to :back, notice: 'HarvestProject was successfully updated.'
      end
    else
      render action: "edit"
    end
  end

  def destroy
    @harvest_project = HarvestProject.find(params[:id])
    @harvest_project.destroy

    respond_to do |format|
      format.html { redirect_to tasks_url }
      format.json { head :no_content }
    end
  end
end

class HarvestProjectsController < ApplicationController
  def index
    @harvest_projects = HarvestProject.all
  end

  def show
    @harvest_project = HarvestProject.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @harvest_project }
    end
  end

  def new
    @harvest_project = HarvestProject.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @harvest_project }
    end
  end

  def edit
    @harvest_project = HarvestProject.find(params[:id])
    @projects = Project.all.collect { |p| [p.title, p.id] }
  end

  def create
    @harvest_project = HarvestProject.new(params[:harvest_project])

    respond_to do |format|
      if @harvest_project.save
        format.html { redirect_to projects_path, notice: 'HarvestProject was successfully created.' }
        format.json { render json: @harvest_project, status: :created, location: @harvest_project }
      else
        format.html { render action: "new" }
        format.json { render json: @harvest_project.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @harvest_project = HarvestProject.find(params[:id])

    respond_to do |format|
      if @harvest_project.update_attributes(params[:harvest_project])
        format.html { redirect_to projects_path, notice: 'HarvestProject was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @harvest_project.errors, status: :unprocessable_entity }
      end
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

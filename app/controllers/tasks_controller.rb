class TasksController < ApplicationController
  # GET /tasks
  # GET /tasks.json
  def index
    @tasks = Task.active.with_timers

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @tasks }
    end
  end

  # GET /tasks/1
  # GET /tasks/1.json
  def show
    @task = Task.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @task }
    end
  end

  # GET /tasks/new
  # GET /tasks/new.json
  def new
    @task = Task.new
    @harvest_tasks = HarvestTask.all.collect{ |t| ["#{t.harvest_project.api_client_name} :: #{t.api_task_name}", t.id]}

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @task }
    end
  end

  # GET /tasks/1/edit
  def edit
    @task = Task.find(params[:id])
    @harvest_tasks = @task.harvest_project_tasks.collect{ |t| [t.api_task_name, t.id]}
  end

  # POST /tasks
  # POST /tasks.json
  def create
    @task = Task.new(params[:task])

    respond_to do |format|
      if @task.save
        format.html { redirect_to projects_path, notice: 'Task was successfully created.' }
        format.json { render json: @task, status: :created, location: @task }
      else
        format.html { render action: "new" }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /tasks/1
  # PUT /tasks/1.json
  def update
    @task = Task.find(params[:id])

      if @task.update_attributes(params[:task])
        unlinked_task = Task.without_harvest_task
        if unlinked_task.count != 0
          @task = unlinked_task.first
          redirect_to edit_task_path(@task), alert: "While you're updating tasks, here is a task that need to be associated with a Harvest Project"
        else
          redirect_to projects_path, notice: 'Task was successfully updated.'
        end
      else
        render action: "edit"
      end
    end
  end

  # DELETE /tasks/1
  # DELETE /tasks/1.json
  def destroy
    @task = Task.find(params[:id])
    @task.destroy

    respond_to do |format|
      format.html { redirect_to tasks_url }
      format.json { head :no_content }
    end
  end
end

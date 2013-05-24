class TimersController < ApplicationController
  # GET /timers/1
  # GET /timers/1.json
  def show
    @timer = Timer.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @timer }
    end
  end

  # GET /timers/start
  def start_timer
    @task = Task.find(params[:task_id])
    if @task && @task.running_timer?
      @task.stop_running_timer
      @timer = @task.start_new_timer
    elsif @task
      @timer = @task.start_new_timer
    else
      raise Error
    end

    respond_to do |format|
      format.html { redirect_to tasks_path, notice: 'Timer started.'}
      format.json { render json: @timer }
    end
  end

  # GET /timers/1/edit
  def edit
    @timer = Timer.find(params[:id])
  end

  # GET /timers/stop
  def stop_timer
    @task = Task.find(params[:task_id])
    if @task && @task.running_timer?
      @task.stop_running_timer
    else
      raise Error
    end

    respond_to do |format|
      format.html { redirect_to tasks_path, notice: 'Timer stopped.' }
      format.json { render json: @timer, status: :created, location: @timer }
    end
  end

  # PUT /timers/1
  # PUT /timers/1.json
  def update
    @timer = Timer.find(params[:id])

    respond_to do |format|
      if @timer.update_attributes(params[:timer])
        format.html { redirect_to @timer, notice: 'Timer was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @timer.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /timers/1
  # DELETE /timers/1.json
  def destroy
    @timer = Timer.find(params[:id])
    @timer.destroy

    respond_to do |format|
      format.html { redirect_to timers_url }
      format.json { head :no_content }
    end
  end
end

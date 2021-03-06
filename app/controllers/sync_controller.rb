class SyncController < ApplicationController
before_filter :authenticate_user!

  def sync_jira_tasks
    if JiraSynchronizer.new(current_user).sync
      redirect_to :back, notice: 'All tasks synchronized!'
    else
      redirect_to :back, alert: 'There was a problem synchronizing your tasks. Please try again.'
    end
  end

  def sync_harvest_tasks
    if HarvestSynchronizer.new({:current_user => current_user}).sync
      unlinked_project = HarvestProject.without_ts_project
      unlinked_task = Task.without_harvest_task
      if unlinked_project.count != 0
        @harvest_project = unlinked_project.first
        redirect_to edit_harvest_project_path(@harvest_project), alert: 'There are projects that need to be associated with a Harvest Project'
      elsif unlinked_task.count != 0
        @task = unlinked_task.first
        redirect_to edit_task_path(@task), alert: 'There are tasks that need to be associated with a Harvest Project'
      else
        redirect_to :back, notice: 'All Harvest projects and tasks synchronized!'
      end
    else
      redirect_to :back, alert: 'There was a problem synchronizing with your Harvest. Please try again.'
    end

  end

  def push_harvest_entries
    unlinked_task = Task.without_harvest_task
    if unlinked_task.count != 0
      @task = unlinked_task.first
      redirect_to edit_task_path(@task), alert: 'There are tasks that need to be associated with a Harvest Project'
    else
      if HarvestPusher.new({:current_user => current_user, :date => params[:date]}).push_harvest_entries
        redirect_to :back, notice: "You've successfully pushed your tasks to Harvest!"
      else
        redirect_to :back, alert: "Warning! Your time was not pushed to Harvest."
      end
    end
  end
end

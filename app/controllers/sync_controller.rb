class SyncController < ApplicationController
before_filter :authenticate_user!

  def sync_jira_tasks
    if JiraSynchronizer.new(current_user).sync
      redirect_to :back, notice: 'All tasks synchronized!'
    else
      redirect_to :back, error: 'There was a problem synchronizing your tasks. Please try again.'
    end
  end

  def sync_harvest_tasks
    if HarvestSynchronizer.new(current_user).sync
      unlinked_project = HarvestProject.without_ts_project
      if unlinked_project.count != 0
        @harvest_project = unlinked_project.first
        redirect_to edit_harvest_project_path(@harvest_project)
      else
        redirect_to :back, notice: 'All Harvest projects and tasks synchronized!'
      end
    else
      redirect_to :back, error: 'There was a problem synchronizing with your Harvest. Please try again.'
    end

  end
end

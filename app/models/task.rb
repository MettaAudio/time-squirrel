class Task < ActiveRecord::Base
  attr_accessible :issue_id, :summary, :project_id, :active, :harvest_task_id
  has_many :timers
  belongs_to :project
  belongs_to :harvest_task
  validate :issue_id, :summary, :presence => true

  scope :active, -> { where('active == ?', true) }
  scope :with_timers, joins(:timers).group('id')
  scope :with_timers_on_day, ->(day) { joins(:timers).where('timers.start_time >= ? and timers.start_time <= ?',day.beginning_of_day, day.end_of_day ).group('tasks.id').order('project_id') }

  delegate :api_task_id, :to => :harvest_task

  def running_timers
    timers.where("start_time IS NOT NULL and end_time IS NULL")
  end

  def project_code
    project.code
  end

  def running_timer?
    running_timers.count != 0
  end

  def start_new_timer
    stop_running_timer
    timers.create!(:start_time => Time.now)
  end

  def stop_running_timer
    return if !running_timer?
    running_timers.each do |timer|
      timer.stop
    end
  end

  def time_events_in_range(start_time, end_time)
    timers.after(start_time).before(end_time)
  end

  def total_time_in_range(start_time, end_time)
    total = 0.0
    time_events_in_range(start_time, end_time).each do |timer|
      total += timer.time_elapsed
    end

    total
  end

  def time_events_this_week
    timers.this_week
  end

  def total_time_on_day(date = Date.today)
    total = 0.0

    timers.after(date.beginning_of_day).before(date.end_of_day).each do |timer|
      total += timer.time_elapsed
    end
    total
  end

  def total_time_this_week
    total = 0.0
    time_events_this_week.each do |timer|
      total += timer.time_elapsed
    end

    total
  end

  def total_time
    total = 0.0
    timers.each do |timer|
      total += timer.time_elapsed
    end

    total
  end

  def harvest_project_tasks
    project.harvest_project.harvest_tasks
  end

  def harvest_project_api_id
    harvest_task.harvest_project.api_project_id
  end

  def classification
    harvest_task.api_task_name
  end
end

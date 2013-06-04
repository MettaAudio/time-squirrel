class Task < ActiveRecord::Base
  attr_accessible :issue_id, :summary, :project_id, :classification
  has_many :timers
  belongs_to :project
  validate :issue_id, :summary, :classification, :presence => true

  scope :with_timers, joins(:timers).group('id')

  def running_timers
    timers.where("start_time IS NOT NULL and end_time IS NULL")
  end

  def running_timer?
    running_timers.count != 0
  end

  def start_new_timer
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
end

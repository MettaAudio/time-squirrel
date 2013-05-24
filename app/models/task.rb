class Task < ActiveRecord::Base
  attr_accessible :issue_id, :summary
  has_many :timers
  validate :issue_id, :summary, :presence => true

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
end

class Timer < ActiveRecord::Base
  attr_accessible :end_time, :start_time, :task_id
  belongs_to :task
  validate :task_id, :presence => true

  scope :before, ->(end_time)   { where("end_time <= ?", end_time) }
  scope :after,  ->(start_time) { where("start_time >= ?", start_time) }
  scope :this_week, -> { self.after(Time.now.at_beginning_of_week).before(Time.now.at_end_of_week) }
  scope :running_timers, -> { where("start_time IS NOT NULL and end_time IS NULL") }

  def stop
    update_attribute(:end_time, Time.now)
  end

  def time_elapsed
    end_time ? (end_time - start_time).to_i : (Time.now - start_time).to_i
  end

  def same_day?
    start_time.day == end_time.day
  end

  def self.total_time_on_day(date = Time.now)
    after(date.beginning_of_day).before(date.end_of_day).collect{|timer| timer.time_elapsed}.inject {|sum,x| sum + x} || 0.0
  end

  def self.total_time_this_week
    this_week.collect{|timer| timer.time_elapsed}.inject {|sum,x| sum + x} || 0.0
  end

  def task_summary
    task.summary
  end
end

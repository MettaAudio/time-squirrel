class Timer < ActiveRecord::Base
  attr_accessible :end_time, :start_time, :task_id
  belongs_to :task
  validate :task_id, :presence => true

  scope :before, ->(end_time)   { where("end_time <= ?", end_time) }
  scope :after,  ->(start_time) { where("start_time >= ?", start_time) }
  scope :this_week, -> { self.after(Time.now.at_beginning_of_week).before(Time.now.at_end_of_week) }

  def stop
    update_attribute(:end_time, Time.now)
  end

  def time_elapsed
    (end_time - start_time).to_i
  end

  def self.total_time_this_week
    this_week.collect{|timer| timer.time_elapsed}.inject {|sum,x| sum + x}
  end
end

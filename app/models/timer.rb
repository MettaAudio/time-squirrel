class Timer < ActiveRecord::Base
  attr_accessible :end_time, :start_time, :task_id
  belongs_to :task
  validate :task_id, :presence => true

  def stop
    update_attribute(:end_time, Time.now)
  end
end

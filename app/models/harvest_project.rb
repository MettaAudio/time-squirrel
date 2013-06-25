class HarvestProject < ActiveRecord::Base
  attr_accessible :api_project_id, :api_project_name, :project_id

  has_many :harvest_tasks
  belongs_to :project

  scope :without_ts_project, where(:project_id => nil)
end

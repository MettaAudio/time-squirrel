class HarvestTask < ActiveRecord::Base
  attr_accessible :api_task_id, :api_task_name, :harvest_project_id

  belongs_to :harvest_project
  has_many :tasks
end

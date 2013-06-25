class Project < ActiveRecord::Base
  has_many :tasks
  has_one :harvest_project

  attr_accessible :code, :title

  scope :with_tasks, joins(:tasks).group('id')
end

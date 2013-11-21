class Project < ActiveRecord::Base
  has_many :tasks
  has_one :harvest_project

  attr_accessible :code, :title, :active

  scope :with_tasks, joins(:tasks).group('id')
  scope :active, -> { where('projects.active == ?', true) }
end

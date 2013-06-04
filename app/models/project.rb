class Project < ActiveRecord::Base
  has_many :tasks
  attr_accessible :code, :title

  scope :with_tasks, joins(:tasks).group('id')
end

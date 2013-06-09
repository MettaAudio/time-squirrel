class HomeController < ApplicationController
  def index
    @total_time = Timer.total_time_this_week
  end

  def daily
    @projects = Project.all
  end

  def weekly
    @projects = Project.all
  end
end

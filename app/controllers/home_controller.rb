class HomeController < ApplicationController
  def index
    @total_time = Timer.total_time_this_week
  end

  def daily
    @projects = Project.all
    @total_time = Timer.total_time_on_day(Time.now)
  end

  def weekly
    @projects = Project.all
  end
end

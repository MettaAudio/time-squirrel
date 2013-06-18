class HomeController < ApplicationController
  def index
    @total_time = Timer.total_time_this_week
  end

  def daily
    @date = params[:day].present? ? Date.parse(params[:day]) : Date.today
    @projects = Project.all
    @total_time = Timer.total_time_on_day(@date)
  end

  def weekly
    @projects = Project.all
  end
end

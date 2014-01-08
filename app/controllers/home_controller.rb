class HomeController < ApplicationController
  def index
    @total_time = Timer.total_time_this_week
    @week_percent_complete = ((((@total_time/60.0)/60.0) * 85.0)/2500.0)*100
    @total_time_this_month = Timer.total_time_this_month
    @month_percent_complete = ((((@total_time_this_month/60.0)/60.0) * 85.0)/10000.0)*100
  end

  def daily
    @date = params[:day].present? ? Date.parse(params[:day]) : Date.today
    @projects = Project.all
    @total_time = Timer.total_time_on_day(@date)
    @timers = Timer.on_day(@date)
  end

  def weekly
    @projects = Project.all
  end
end

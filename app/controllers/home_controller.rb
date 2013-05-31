class HomeController < ApplicationController
  def index
    @total_time = Timer.total_time_this_week
  end
end

module HomeHelper

  def weekly_time_percentage
    percentage = (Time.now - Time.now.at_beginning_of_week)/seconds_per_work_week
    percentage*100
  end

  def seconds_per_work_week
    (60*60*24*5)
  end

  def monthly_time_percentage
    percentage = business_days_to_date/total_business_days_in_month
    percentage*100
  end

  def business_days_to_date
    business_days_between(Date.today.at_beginning_of_month, Date.today).to_f
  end

  def total_business_days_in_month
    business_days_between(Date.today.at_beginning_of_month, Date.today.at_end_of_month).to_f
  end

  def business_days_between(date1, date2)
  business_days = 0
    while date2 > date1
     business_days += 1 unless date2.saturday? or date2.sunday?
     date2 = date2 - 1.day
    end
    business_days
  end

  def ahead_of_monthly_goal?
    @month_percent_complete > monthly_time_percentage
  end

  def ahead_of_weekly_goal?
    @week_percent_complete > weekly_time_percentage
  end
end

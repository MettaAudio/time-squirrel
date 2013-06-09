module ApplicationHelper

  def display_base_errors resource
    return '' if (resource.errors.empty?) or (resource.errors[:base].empty?)
    messages = resource.errors[:base].map { |msg| content_tag(:p, msg) }.join
    html = <<-HTML
    <div class="alert alert-error alert-block">
      <button type="button" class="close" data-dismiss="alert">&#215;</button>
      #{messages}
    </div>
    HTML
    html.html_safe
  end

  def formatted_duration(elapsed_time)
    elapsed_time.present? ? Time.at(elapsed_time).utc.strftime("%H:%M") : '-'
  end

  def day_hour_minute(time)
    time.present? ? time.in_time_zone("Eastern Time (US & Canada)").strftime('%a, %b %e, %l:%M %p') : '-'
  end

  def hour_minute(time)
    time.present? ? time.in_time_zone("Eastern Time (US & Canada)").strftime('%l:%M %p') : '-'
  end

  def day(time)
    time.in_time_zone("Eastern Time (US & Canada)").strftime('%A, %B %e')
  end

end

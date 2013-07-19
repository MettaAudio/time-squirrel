class HarvestPusher
  attr_reader :current_user, :date

  def initialize(args)
    @current_user = args[:current_user]
    @date         = Date.parse(args[:date])
  end

  def harvest
    @harvest = Harvest.new(current_user)
  end

  def push_harvest_entries
    Task.with_timers_on_day(date).each do |task|
      push(task)
    end
  end

  def push(task)
    response = harvest.request('/daily/add', :post, xml_payload(task))

    if success?(response)
      # throw a party
    else
      raise "There was a problem syncing your task. Code: #{response.code}, Body: #{response.body}"
    end
  end

  def success?(response)
    response.code == '201'
  end

  def xml_payload(task)
    builder = Nokogiri::XML::Builder.new do |xml|
      xml.request {
        xml.notes concatenated_notes(task)
        xml.hours time_in_decimal(task.total_time_on_day(date))
        xml.project_id task.harvest_project_api_id, :type => 'integer'
        xml.task_id task.api_task_id, :type => 'integer'
        xml.spent_at harvest_formatted_date, :type => 'date'
      }
    end

    builder.to_xml
  end

  def concatenated_notes(task)
    "#{task.issue_id} #{task.summary}"
  end

  def harvest_formatted_date
    date.strftime('%a, %d %b %Y')
  end

  def time_in_decimal(minutes)
    minutes/60.0/60.0
  end
end

# harvest.request('/daily/add', :post)

# success is 201

# <request>
#   <notes>Test api support</notes>
#   <hours>3</hours>
#   <project_id type="integer">3</project_id>
#   <task_id type="integer">14</task_id>
#   <spent_at type="date">Tue, 17 Oct 2006</spent_at>
# </request>
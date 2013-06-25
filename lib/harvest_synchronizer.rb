class HarvestSynchronizer
  attr_reader :current_user

  def initialize(current_user)
    @current_user = current_user
  end

  def harvest
    @harvest = Harvest.new(current_user)
  end

  def sync
    sync_projects
    sync_tasks
  end

  def sync_projects
    current_projects.each do |project|
      harvest_project = HarvestProject.find_or_create_by_api_project_id(project[:api_project_id])
      harvest_project.update_attributes(project)
    end
  end

  def sync_tasks
    current_tasks.each do |task|
      harvest_task = HarvestTask.find_or_create_by_api_task_id_and_harvest_project_id(task[:api_task_id], task[:harvest_project_id])
      harvest_task.update_attributes(task)
    end
  end

  def current_projects
    array_of_projects = []

    daily_xml.css("project").each do |xml_project|
      attributes = {}
        attributes[:api_project_name] = xml_project.css('name').first.text
        attributes[:api_project_id]   = xml_project.css('id').first.text
        attributes[:api_client_name]  = xml_project.css("client").first.text
      array_of_projects << attributes
    end
    array_of_projects
  end

  def current_tasks
    array_of_tasks = []

    daily_xml.css("project").each do |xml_project|
      xml_project.css("task").each do |task|
        attributes = {}
        attributes[:harvest_project_id] = find_harvest_project(xml_project).try(:id)
        attributes[:api_task_name]      = task.css("name").text
        attributes[:api_task_id]        = task.css("id").text
        array_of_tasks << attributes
      end
    end
    array_of_tasks
  end

  def find_harvest_project(xml_project)
    project = HarvestProject.find_by_api_project_id(xml_project.css('id').first.text)
  end

  def daily_xml
    @_daily_xml ||= harvest.request('/daily', :get)
    if @_daily_xml.code == '200'
      Nokogiri::XML(@_daily_xml.body)
    else
      raise "[ERROR] Harvest Daily XML Error. Response Code is #{@_daily_xml.code}. Response Body: #{@_daily_xml.body}"
    end
  end

end
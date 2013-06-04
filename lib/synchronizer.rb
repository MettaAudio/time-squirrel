class Synchronizer
  attr_reader :current_user

  def initialize(current_user)
    @current_user = current_user
  end

  def jira
    @jira = Jira.new(current_user)
  end

  def sync
    sync_projects
    sync_tasks
  end

  def sync_tasks
    current_issues.each do |issue|
     task  = Task.find_or_create_by_issue_id(issue[:issue_detail][:issue_id])
     task.update_attributes!(issue[:issue_detail])
     task.update_attribute(:project, project_for_issue(issue))
    end
  end

  def project_for_issue(issue)
    Project.find_by_code(issue[:project])
  end

  def sync_projects
    current_projects.each do |jira_project|
      project = Project.find_or_create_by_code(jira_project[:code])
      project.update_attributes!(jira_project)
    end
  end

  def current_projects
    jira.retrieve_all_projects
  end

  def current_issues
    jira.retrieve_all_issues
  end
end
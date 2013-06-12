class Jira
  include HTTParty
  require 'json'
  default_params :output => 'json'

  attr_reader :base_uri, :fields, :jql, :max_results, :current_user

  def initialize(current_user)
    @current_user = current_user
    @base_uri     = 'https://railsdog.atlassian.net/rest/api/latest/'
    @fields       = ["key", "summary", "project", "status"]
    @jql          = "assignee='#{user_id}' and issuetype in (Bug, Improvement, 'New Feature', Story, Task, Sub-task, 'Technical task') and updated > #{Date.today - 14}"
    @max_results  = 50
  end

  def retrieve_all_issues
    parsed_results = []
    begin
      issues["issues"].each do |issue|
        parsed_issue = { :project => project_key(issue) }
        parsed_issue.merge!({
          :issue_detail => {
            :issue_id => issue["key"],
            :summary  => issue["fields"]["summary"],
            :active   => (issue["fields"]["status"]["name"] != "Resolved")
          }
        })
        parsed_results << parsed_issue
      end

      parsed_results
    rescue
      raise "Task Problem"
    end
  end

  def project_key(issue)
    issue["fields"]["project"]["key"]
  end

  def issues
    @_issue || begin
      response = self.class.post(issue_uri,
                      :basic_auth => { :username => user_id, :password => secret },
                      :body       => issue_payload,
                      :headers => {'Content-Type' => 'application/json'} )
      @_issue = JSON.parse(response.body)
    end
  end

  def issue_uri
    base_uri + 'search'
  end

  def project_uri
    base_uri + 'project'
  end

  def retrieve_all_projects
    parsed_results = []
    begin
      projects.each do |project|
        next if project["key"] == "DEMO"
        parsed_results << {
          :code => project["key"],
          :title  => project["name"],
        }
      end

      parsed_results
    rescue
      raise "Project Problem"
    end
  end

  def projects
    @_projects || begin
      response = self.class.get(project_uri,
                      :basic_auth => { :username => user_id, :password => secret },
                      :headers => {'Content-Type' => 'application/json'} )
      @_projects = JSON.parse(response.body)
    end
  end

  def issue_payload
    { :jql        => jql,
      :maxResults => max_results,
      :fields     => fields }.to_json
  end

  def user_id
    current_user.jira_user_id
  end

  def secret
    current_user.jira_secret
  end
end
class Jira
  include HTTParty
  require 'json'
  base_uri 'https://railsdog.atlassian.net/rest/api/latest/search'
  default_params :output => 'json'

  def self.get_issues(user_id, secret)
    response = post(base_uri,
                    :basic_auth => { :username => user_id, :password => secret },
                    :body       => payload,
                    :headers => {'Content-Type' => 'application/json'} )
    JSON.parse(response.body)
  end

  def self.payload
    { :jql => "project='JUN' and assignee='jking' and resolution='unresolved' and issuetype in (Bug, Improvement, 'New Feature', Story, Task, Sub-task, 'Technical task')",
      :maxResults => 5,
      :fields => ["id", "key", "resolution"] }.to_json
  end

end
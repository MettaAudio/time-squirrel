class TaskRabbitHarvest
  attr_reader :harvest

  def initialize(current_user)
    @current_user = current_user
    @harvest_subdomain = current_user.harvest_subdomain
    @harvest_username = current_user.harvest_username
    @harvest_password = current_user.harvest_password
    @harvest = Harvest.hardy_client(@harvest_subdomain, @harvest_username, @harvest_password)
  end

  def get_projects
    harvest.users.all.inspect
  end
end


# curl -H 'Content-Type: application/xml' -H 'Accept: application/xml' \
  # -u jking@railsdog.com:C3y/AuJ3LcfY^XkDWj \
  # https://railsdog.harvestapp.com/account/who_am_i
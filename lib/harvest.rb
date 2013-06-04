########################################################################
#
# The full HARVEST API documentation can be found at:
#
#   http://getharvest.com/api
#
# Please review the documentation before sending in your questions.
#
########################################################################

# Business accounts have ssl support enabled. Set this to false if your
# WEB UI is accessible via http:// instead of https://. Note that
# Harvest will redirect you to the proper protocol regardless of
# this. You just need to handle the redirection pragmatically. This
# sample does this, your implementation should save the last known
# protocol to avoid increased latency.
HAS_SSL          = true

class Harvest
  attr_reader :harvest_username, :harvest_password, :company, :user_agent

  def initialize(current_user)
    @company             = current_user.harvest_subdomain
    @preferred_protocols = [HAS_SSL, ! HAS_SSL]
    @harvest_password    = current_user.harvest_password
    @harvest_username    = current_user.harvest_username
    @user_agent          = 'Something nice here'
    connect!
  end

  # HTTP headers you need to send with every request.
  def headers
    {
      # Declare that you expect response in XML after a _successful_
      # response.
      "Accept"        => "application/xml",

      # Promise to send XML.
      "Content-Type"  => "application/xml; charset=utf-8",

      # All requests will be authenticated using HTTP Basic Auth, as
      # described in rfc2617. Your library probably has support for
      # basic_auth built in, I've passed the Authorization header
      # explicitly here only to show what happens at HTTP level.
      "Authorization" => "Basic #{auth_string}",

      # Tell Harvest a bit about your application.
      "User-Agent"    => user_agent
    }
  end

  def auth_string
    Base64.encode64("#{harvest_username}:#{harvest_password}").delete("\r\n")
  end

  def request path, method = :get, body = ""
    response = send_request( path, method, body)
    if response.class < Net::HTTPSuccess
      # response in the 2xx range
      on_completed_request
      return response
    elsif response.class == Net::HTTPServiceUnavailable
      # response status is 503, you have reached the API throttle
      # limit. Harvest will send the "Retry-After" header to indicate
      # the number of seconds your boot needs to be silent.
      raise "Got HTTP 503 three times in a row" if retry_counter > 3
      sleep(response['Retry-After'].to_i + 5)
      request(path, method, body)
    elsif response.class == Net::HTTPFound
      # response was a redirect, most likely due to protocol
      # mismatch. Retry again with a different protocol.
      @preferred_protocols.shift
      raise "Failed connection using http or https" if @preferred_protocols.empty?
      connect!
      request(path, method, body)
    else
      dump_headers = response.to_hash.map { |h,v| [h.upcase,v].join(': ') }.join("\n")
      raise "#{response.message} (#{response.code})\n\n#{dump_headers}\n\n#{response.body}\n"
    end
  end

  private

  def connect!
    port = has_ssl ? 443 : 80
    @connection             = Net::HTTP.new("#{company}.harvestapp.com", port)
    @connection.use_ssl     = has_ssl
    @connection.verify_mode = OpenSSL::SSL::VERIFY_NONE if has_ssl
  end

  def has_ssl
    @preferred_protocols.first
  end

  def send_request path, method = :get, body = ''
    case method
    when :get
      @connection.get(path, headers)
    when :post
      @connection.post(path, body, headers)
    when :put
      @connection.put(path, body, headers)
    when :delete
      @connection.delete(path, headers)
    end
  end

  def on_completed_request
    @retry_counter = 0
  end

  def retry_counter
    @retry_counter ||= 0
    @retry_counter += 1
  end

end

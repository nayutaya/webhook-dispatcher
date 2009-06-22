
class WebHookPublisher::Response
  def initialize
    @status    = :unknown
    @http_code = nil
    @message   = nil
    @exception = nil
  end

  attr_reader :status, :http_code, :message, :exception

  def success?
    return false
  end
end

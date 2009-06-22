
class WebHookPublisher::Response
  def initialize(options = {})
    options = options.dup
    @success   = (options.delete(:success) == true)
    @status    = options.delete(:status)    || :unknown
    @http_code = options.delete(:http_code) || nil
    @message   = options.delete(:message)   || nil
    @exception = options.delete(:exception) || nil
    raise(ArgumentError, "invalid parameter") unless options.empty?
  end

  attr_reader :success, :status, :http_code, :message, :exception

  def success?
    return self.success
  end
end

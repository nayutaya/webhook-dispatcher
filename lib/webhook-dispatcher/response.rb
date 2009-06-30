
class WebHookDispatcher::Response
  def initialize(options = {})
    options = options.dup
    @status    = options.delete(:status)    || :unknown
    @http_code = options.delete(:http_code) || nil
    @message   = options.delete(:message)   || nil
    @exception = options.delete(:exception) || nil
    raise(ArgumentError, "invalid parameter") unless options.empty?
  end

  attr_reader :status, :http_code, :message, :exception

  def success?
    return (self.status == :success)
  end
end

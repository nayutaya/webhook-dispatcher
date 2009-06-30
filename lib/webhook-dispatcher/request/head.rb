
require "webhook-dispatcher/request/base"

class WebHookDispatcher::Request::Head < WebHookDispatcher::Request::Base
  def initialize(uri)
    super(uri)
  end

  def create_http_request
    return Net::HTTP::Head.new(self.uri.request_uri)
  end
end

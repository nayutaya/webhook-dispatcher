
require "webhook-dispatcher/request/base"

class WebHookDispatcher::Request::Get < WebHookDispatcher::Request::Base
  def initialize(uri)
    super(uri)
  end

  def create_http_request
    return Net::HTTP::Get.new(self.uri.request_uri)
  end
end


require "webhook-publisher/request/base"

class WebHookPublisher::Request::Get < WebHookPublisher::Request::Base
  def initialize(uri)
    super(uri)
  end
end

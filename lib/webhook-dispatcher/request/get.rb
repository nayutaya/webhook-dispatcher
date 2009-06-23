
require "webhook-dispatcher/request/base"

class WebHookDispatcher::Request::Get < WebHookDispatcher::Request::Base
  def initialize(uri)
    super(uri)
  end
end

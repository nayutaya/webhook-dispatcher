
require "webhook-dispatcher/request/base"

class WebHookDispatcher::Request::Post < WebHookDispatcher::Request::Base
  def initialize(uri, body)
    super(uri)
    @body = body
  end

  attr_accessor :body
end

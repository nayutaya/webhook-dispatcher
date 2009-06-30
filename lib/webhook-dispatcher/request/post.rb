
require "webhook-dispatcher/request/base"

class WebHookDispatcher::Request::Post < WebHookDispatcher::Request::Base
  def initialize(uri, data)
    super(uri)
    @data = data
  end

  attr_accessor :data
end

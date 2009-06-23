
require "uri"

class WebHookDispatcher
  module Request
  end
end

class WebHookDispatcher::Request::Base
  def initialize(uri)
    @uri = uri
  end

  attr_accessor :uri
end

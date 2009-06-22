
require "uri"

class WebHookPublisher
  module Request
  end
end

class WebHookPublisher::Request::Base
  def initialize(uri)
    @uri = uri
  end

  attr_accessor :uri
end

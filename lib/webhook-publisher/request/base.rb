
require "uri"

class WebHookPublisher::Request
end

class WebHookPublisher::Request::Base
  def initialize(uri)
    @uri = uri
  end

  attr_accessor :uri
end

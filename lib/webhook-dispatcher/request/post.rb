
require "webhook-dispatcher/request/base"

class WebHookDispatcher::Request::Post < WebHookDispatcher::Request::Base
  def initialize(uri, body = nil)
    super(uri)
    @body = body
  end

  attr_accessor :body

  def create_http_request
    req = Net::HTTP::Post.new(self.uri.request_uri)
    req.body = self.body
    return req
  end
end

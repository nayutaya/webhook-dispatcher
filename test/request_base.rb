
require File.dirname(__FILE__) + "/test_helper"
require "webhook-publisher/core"
require "webhook-publisher/request/base"

class RequestBaseTest < Test::Unit::TestCase
  def setup
    @klass = WebHookPublisher::Request::Base
  end

  def test_initialize
    @klass.new
  end
end

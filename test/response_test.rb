
require File.dirname(__FILE__) + "/test_helper"
require "webhook-publisher/core"
require "webhook-publisher/response"

class ResponseTest < Test::Unit::TestCase
  def setup
    @klass = WebHookPublisher::Response
  end

  def test_initialize
    res = @klass.new
    assert_equal(false,    res.success?)
    assert_equal(:unknown, res.status)
    assert_equal(nil,      res.http_code)
    assert_equal(nil,      res.message)
    assert_equal(nil,      res.exception)
  end
end

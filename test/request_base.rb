
require File.dirname(__FILE__) + "/test_helper"
require "webhook-publisher/request/base"

class RequestBaseTest < Test::Unit::TestCase
  def setup
    @klass = WebHookPublisher::Request::Base
  end

  def test_initialize
    req = @klass.new(URI.parse("http://example.jp"))
    assert_equal(URI.parse("http://example.jp"), req.uri)
  end

  def test_uri_attr
    req = @klass.new(URI.parse("http://example.com"))
    req.uri = URI.parse("http://example.org")
    assert_equal(URI.parse("http://example.org"), req.uri)
  end
end

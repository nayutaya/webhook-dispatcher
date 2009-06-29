
require File.dirname(__FILE__) + "/test_helper"
require "webhook-dispatcher/request/base"

class RequestBaseTest < Test::Unit::TestCase
  def setup
    @klass = WebHookDispatcher::Request::Base
  end

  #
  # 初期化
  #

  def test_initialize
    req = @klass.new(URI.parse("http://example.jp"))
    assert_equal(URI.parse("http://example.jp"), req.instance_eval { @uri })
  end

  #
  # インスタンスメソッド
  #

  def test_uri
    req = @klass.new(URI.parse("http://example.com"))
    assert_equal(URI.parse("http://example.com"), req.uri)
    req.uri = URI.parse("http://example.org")
    assert_equal(URI.parse("http://example.org"), req.uri)
  end
end

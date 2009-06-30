
require File.dirname(__FILE__) + "/../test_helper"
require "webhook-dispatcher/request/post"

class RequestPostTest < Test::Unit::TestCase
  def setup
    @klass = WebHookDispatcher::Request::Post
  end

  #
  # 初期化
  #

  def test_initialize
    req = @klass.new(URI.parse("http://example.jp"), "data")
    assert_equal(URI.parse("http://example.jp"), req.uri)
  end

  #
  # インスタンスメソッド
  #

  def test_body
    req = @klass.new(URI.parse("http://example.jp"), "a")
    assert_equal("a", req.body)
    req.body = "b"
    assert_equal("b", req.body)
  end
end

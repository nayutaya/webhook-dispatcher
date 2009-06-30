
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

  def test_data
    req = @klass.new(URI.parse("http://example.jp"), "a")
    assert_equal("a", req.data)
    req.data = "b"
    assert_equal("b", req.data)
  end
end

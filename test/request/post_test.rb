
require File.dirname(__FILE__) + "/../test_helper"
require "webhook-dispatcher/request/post"

class RequestPostTest < Test::Unit::TestCase
  def setup
    @klass = WebHookDispatcher::Request::Post

    @example_jp = URI.parse("http://example.jp")
  end

  #
  # 初期化
  #

  def test_initialize
    req = @klass.new(@example_jp, "body")
    assert_equal(@example_jp, req.uri)
    assert_equal("body",      req.body)
  end

  def test_initialize__default
    req = @klass.new(@example_jp)
    assert_equal(@example_jp, req.uri)
    assert_equal(nil,         req.body)
  end

  #
  # インスタンスメソッド
  #

  def test_body
    req = @klass.new(@example_jp, "a")
    assert_equal("a", req.body)
    req.body = "b"
    assert_equal("b", req.body)
  end

  def test_create_http_request
    req = @klass.new(URI.parse("http://example.jp/path?query"), "body").create_http_request
    assert_kind_of(Net::HTTP::Post, req)
    assert_equal("/path?query", req.path)
    assert_equal("body",        req.body)
  end
end

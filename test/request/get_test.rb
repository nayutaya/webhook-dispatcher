
require File.dirname(__FILE__) + "/../test_helper"
require "webhook-dispatcher/request/get"

class RequestGetTest < Test::Unit::TestCase
  def setup
    @klass = WebHookDispatcher::Request::Get

    @example_jp = URI.parse("http://example.jp")
  end

  #
  # 初期化
  #

  def test_initialize
    req = @klass.new(@example_jp)
    assert_equal(@example_jp, req.uri)
  end

  #
  # インスタンスメソッド
  #

  def test_create_http_request
    req = @klass.new(URI.parse("http://example.jp/path?query")).create_http_request
    assert_kind_of(Net::HTTP::Get, req)
    assert_equal("/path?query", req.path)
  end
end

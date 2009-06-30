
require File.dirname(__FILE__) + "/../test_helper"
require "webhook-dispatcher/request/base"

class RequestBaseTest < Test::Unit::TestCase
  def setup
    @klass = WebHookDispatcher::Request::Base

    @example_jp  = URI.parse("http://example.jp")
    @example_com = URI.parse("http://example.com")
  end

  #
  # 初期化
  #

  def test_initialize
    req = @klass.new(@example_jp)
    assert_equal(@example_jp, req.instance_eval { @uri })
  end

  #
  # インスタンスメソッド
  #

  def test_uri
    req = @klass.new(@example_jp)
    assert_equal(@example_jp, req.uri)
    req.uri = @example_com
    assert_equal(@example_com, req.uri)
  end

  def test_create_http_request
    assert_raise(NotImplementedError) {
      @klass.new(@example_jp).create_http_request
    }
  end
end

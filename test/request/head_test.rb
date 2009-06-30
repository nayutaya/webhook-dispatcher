
require File.dirname(__FILE__) + "/../test_helper"
require "webhook-dispatcher/request/head"

class RequestHeadTest < Test::Unit::TestCase
  def setup
    @klass = WebHookDispatcher::Request::Head
  end

  #
  # 初期化
  #

  def test_initialize
    req = @klass.new(URI.parse("http://example.jp"))
    assert_equal(URI.parse("http://example.jp"), req.uri)
  end
end


require File.dirname(__FILE__) + "/test_helper"
require "webhook-dispatcher/core"

class CoreTest < Test::Unit::TestCase
  def setup
    @klass = WebHookDispatcher
  end

  #
  # クラスメソッド
  #

  def test_self_open_timeout
    assert_equal(nil, @klass.open_timeout)
    @klass.open_timeout = 5
    assert_equal(5, @klass.open_timeout)
  end

  def test_self_read_timeout
    assert_equal(nil, @klass.read_timeout)
    @klass.read_timeout = 5
    assert_equal(5, @klass.read_timeout)
  end

  def test_self_user_agent
    assert_equal(nil, @klass.user_agent)
    @klass.user_agent = "ie"
  end
end

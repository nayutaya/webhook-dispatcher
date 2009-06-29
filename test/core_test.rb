
require File.dirname(__FILE__) + "/test_helper"
require "webhook-dispatcher/core"

class CoreTest < Test::Unit::TestCase
  def setup
    @klass = WebHookDispatcher
    @dispatcher = @klass.new
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

  #
  # インスタンスメソッド
  #

  def test_open_timeout
    @dispatcher.open_timeout = 10
    assert_equal(10, @dispatcher.open_timeout)
  end

  def test_read_timeout
    @dispatcher.read_timeout = 10
    assert_equal(10, @dispatcher.read_timeout)
  end

  def test_user_agent
    @dispatcher.user_agent = "firefox"
    assert_equal("firefox", @dispatcher.user_agent)
  end
end

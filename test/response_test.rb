
require File.dirname(__FILE__) + "/test_helper"
require "webhook-dispatcher/core"
require "webhook-dispatcher/response"

class ResponseTest < Test::Unit::TestCase
  def setup
    @klass = WebHookDispatcher::Response
  end

  def test_initialize
    res = @klass.new(
      :success   => true,
      :status    => :success,
      :http_code => 200,
      :message   => "OK",
      :exception => RuntimeError.new)
    assert_equal(true,     res.success)
    assert_equal(true,     res.success?)
    assert_equal(:success, res.status)
    assert_equal(200,      res.http_code)
    assert_equal("OK",     res.message)
    assert_kind_of(RuntimeError, res.exception)
  end

  def test_initialize__default
    res = @klass.new
    assert_equal(false,    res.success)
    assert_equal(false,    res.success?)
    assert_equal(:unknown, res.status)
    assert_equal(nil,      res.http_code)
    assert_equal(nil,      res.message)
    assert_equal(nil,      res.exception)
  end

  def test_initialize__invalid_parameter
    assert_raise(ArgumentError) {
      @klass.new(:invalid => true)
    }
  end
end

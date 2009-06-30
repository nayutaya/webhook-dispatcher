
require File.dirname(__FILE__) + "/test_helper"
require "webhook-dispatcher/core"
require "webhook-dispatcher/response"

class ResponseTest < Test::Unit::TestCase
  def setup
    @klass = WebHookDispatcher::Response
  end

  def test_initialize
    response = @klass.new(
      :status    => :success,
      :http_code => 200,
      :message   => "OK",
      :exception => RuntimeError.new)
    assert_equal(true,     response.success?)
    assert_equal(:success, response.status)
    assert_equal(200,      response.http_code)
    assert_equal("OK",     response.message)
    assert_kind_of(RuntimeError, response.exception)
  end

  def test_initialize__default
    response = @klass.new
    assert_equal(false,    response.success?)
    assert_equal(:unknown, response.status)
    assert_equal(nil,      response.http_code)
    assert_equal(nil,      response.message)
    assert_equal(nil,      response.exception)
  end

  def test_initialize__invalid_parameter
    assert_raise(ArgumentError) {
      @klass.new(:invalid => true)
    }
  end
end

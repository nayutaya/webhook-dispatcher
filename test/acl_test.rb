
require File.dirname(__FILE__) + "/test_helper"
require "webhook-publisher/core"
require "webhook-publisher/acl"

class AclTest < Test::Unit::TestCase
  def setup
    @klass = WebHookPublisher::Acl
    @acl   = @klass.new
  end

  def test_intialize
    acl = @klass.new
    assert_equal(0, acl.size)
  end

  def test_add_allow
    assert_equal(0, @acl.size)
    @acl.add_allow(IPAddr.new("0.0.0.0/0"))
    assert_equal(1, @acl.size)
    @acl.add_allow(IPAddr.new("0.0.0.0/0"))
    assert_equal(2, @acl.size)
  end

  def test_add_deny
    assert_equal(0, @acl.size)
    @acl.add_deny(IPAddr.new("0.0.0.0/0"))
    assert_equal(1, @acl.size)
    @acl.add_deny(IPAddr.new("0.0.0.0/0"))
    assert_equal(2, @acl.size)
  end

  def test_allow?
    assert_equal(true, @acl.allow?(IPAddr.new("127.0.0.1")))
    @acl.add_allow(IPAddr.new("0.0.0.0/0"))
    assert_equal(true, @acl.allow?(IPAddr.new("127.0.0.1")))
    @acl.add_deny(IPAddr.new("127.0.0.0/8"))
    assert_equal(false, @acl.allow?(IPAddr.new("127.0.0.1")))
  end
end

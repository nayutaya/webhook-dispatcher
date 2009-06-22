
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

  #
  # クラスメソッド
  #

  def test_self_to_ipaddr
    assert_equal(
      IPAddr.new("127.0.0.0/8"),
      @klass.to_ipaddr(IPAddr.new("127.0.0.0/8")))
    assert_equal(
      IPAddr.new("127.0.0.0/8"),
      @klass.to_ipaddr("127.0.0.0/8"))
    assert_equal(
      IPAddr.new("0.0.0.0/0"),
      @klass.to_ipaddr(:all))

    assert_raise(ArgumentError) {
      @klass.to_ipaddr(:invalid)
    }
  end

  #
  # インスタンスメソッド
  #

  def test_add_allow
    assert_equal(0, @acl.size)
    @acl.add_allow("0.0.0.0/0")
    assert_equal(1, @acl.size)
    @acl.add_allow("0.0.0.0/0")
    assert_equal(2, @acl.size)
  end

  def test_add_deny
    assert_equal(0, @acl.size)
    @acl.add_deny("0.0.0.0/0")
    assert_equal(1, @acl.size)
    @acl.add_deny("0.0.0.0/0")
    assert_equal(2, @acl.size)
  end

  def test_allow?
    assert_equal(true, @acl.allow?("127.0.0.1"))
    @acl.add_deny("127.0.0.0/8")
    assert_equal(false, @acl.allow?("127.0.0.1"))
  end

  def test_deny?
    assert_equal(false, @acl.deny?("127.0.0.1"))
    @acl.add_deny("127.0.0.0/8")
    assert_equal(true, @acl.deny?("127.0.0.1"))
  end

  def test_complex1
    @acl.add_deny("0.0.0.0/0")
    @acl.add_allow("127.0.0.0/8")

    assert_equal(false, @acl.allow?("126.255.255.255"))
    assert_equal(true,  @acl.allow?("127.0.0.0"))
    assert_equal(true,  @acl.allow?("127.255.255.255"))
    assert_equal(false, @acl.allow?("128.0.0.0"))
  end

  def test_complex2
    @acl.add_deny("0.0.0.0/0")
    @acl.add_allow("192.168.1.0/24")
    @acl.add_allow("192.168.3.0/24")
    @acl.add_deny("192.168.1.127")

    assert_equal(false, @acl.allow?("192.168.0.0"))
    assert_equal(true,  @acl.allow?("192.168.1.0"))
    assert_equal(false, @acl.allow?("192.168.1.127"))
    assert_equal(true,  @acl.allow?("192.168.1.255"))
    assert_equal(false, @acl.allow?("192.168.2.0"))
    assert_equal(true,  @acl.allow?("192.168.3.0"))
    assert_equal(true,  @acl.allow?("192.168.3.255"))
  end
end

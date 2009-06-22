
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

  def test_with__none
    @acl.with { }
    assert_equal(0, @acl.size)
  end

  def test_with__allow
    @acl.with { allow :all }
    assert_equal(1, @acl.size)
  end

  def test_with__deny
    @acl.with { deny :all }
    assert_equal(1, @acl.size)
  end

  def test_with__without_block
    assert_raise(ArgumentError) {
      @acl.with
    }
  end

  def test_allow?
    assert_equal(true, @acl.allow?("127.0.0.1"))
    @acl.add_deny("127.0.0.0/8")
    assert_equal(false, @acl.allow?("127.0.0.1"))
    @acl.add_allow("127.0.0.0/8")
    assert_equal(true, @acl.allow?("127.0.0.1"))
  end

  def test_deny?
    assert_equal(false, @acl.deny?("127.0.0.1"))
    @acl.add_deny("127.0.0.0/8")
    assert_equal(true, @acl.deny?("127.0.0.1"))
    @acl.add_allow("127.0.0.0/8")
    assert_equal(false, @acl.deny?("127.0.0.1"))
  end

  def test_complex1
    @acl.with {
      deny :all
      allow "127.0.0.0/8"
    }

    assert_equal(false, @acl.allow?("126.255.255.255"))
    assert_equal(true,  @acl.allow?("127.0.0.0"))
    assert_equal(true,  @acl.allow?("127.255.255.255"))
    assert_equal(false, @acl.allow?("128.0.0.0"))
  end

  def test_complex2
    @acl.with {
      deny :all
      allow "192.168.1.0/24"
      allow "192.168.3.0/24"
      deny "192.168.1.127"
    }

    assert_equal(false, @acl.allow?("192.168.0.0"))
    assert_equal(true,  @acl.allow?("192.168.1.0"))
    assert_equal(false, @acl.allow?("192.168.1.127"))
    assert_equal(true,  @acl.allow?("192.168.1.255"))
    assert_equal(false, @acl.allow?("192.168.2.0"))
    assert_equal(true,  @acl.allow?("192.168.3.0"))
    assert_equal(true,  @acl.allow?("192.168.3.255"))
  end

  #
  # RecordBaseクラス
  #

  def test_record_base_initialize
    assert_equal(
      IPAddr.new("127.0.0.0/8"),
      @klass::RecordBase.new(IPAddr.new("127.0.0.0/8")).ipaddr)
    assert_equal(
      IPAddr.new("127.0.0.0/8"),
      @klass::RecordBase.new("127.0.0.0/8").ipaddr)
    assert_equal(
      IPAddr.new("0.0.0.0/0"),
      @klass::RecordBase.new(:all).ipaddr)

    assert_raise(ArgumentError) {
      @klass::RecordBase.new(:invalid)
    }
  end
end

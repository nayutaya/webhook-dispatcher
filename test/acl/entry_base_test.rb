
require File.dirname(__FILE__) + "/../test_helper"
require "webhook-dispatcher/acl/entry_base"

class EntryBaseTest < Test::Unit::TestCase
  def setup
    @klass = WebHookDispatcher::Acl::EntryBase
  end

  def test_initialize__default
    entry = @klass.new
    assert_equal(
      [IPAddr.new("0.0.0.0/0"), nil, (0..65535)],
      entry.to_a)
  end

  def test_initialize__all
    assert_equal(
      [IPAddr.new("0.0.0.0/0"), nil, (0..65535)],
      @klass.new(:all).to_a)
    assert_equal(
      [IPAddr.new("0.0.0.0/0"), nil, (0..65535)],
      @klass.new({}).to_a)
  end

  def test_initialize__addr
    assert_equal(
      [IPAddr.new("0.0.0.0/0"), nil, (0..65535)],
      @klass.new(:addr => :all).to_a)
    assert_equal(
      [IPAddr.new("127.0.0.1/32"), nil, (0..65535)],
      @klass.new(:addr => "127.0.0.1").to_a)
    assert_equal(
      [IPAddr.new("127.0.0.0/8"), nil, (0..65535)],
      @klass.new(:addr => IPAddr.new("127.0.0.0/8")).to_a)

    assert_raise(ArgumentError) {
      @klass.new(:addr => :invalid)
    }
  end

  def test_initialize__name
    assert_equal(
      [nil, "www.google.co.jp", (0..65535)],
      @klass.new(:name => "WWW.GOOGLE.CO.JP").to_a)
    assert_equal(
      [nil, /google\.co\.jp/, (0..65535)],
      @klass.new(:name => /google\.co\.jp/).to_a)

    assert_raise(ArgumentError) {
      @klass.new(:name => :invalid)
    }
  end

  def test_initialize__port
    assert_equal(
      [IPAddr.new("0.0.0.0/0"), nil, (0..65535)],
      @klass.new(:port => :all).to_a)
    assert_equal(
      [IPAddr.new("0.0.0.0/0"), nil, [80]],
      @klass.new(:port => 80).to_a)
    assert_equal(
      [IPAddr.new("0.0.0.0/0"), nil, [1, 2, 3]],
      @klass.new(:port => [3, 2, 1]).to_a)
    assert_equal(
      [IPAddr.new("0.0.0.0/0"), nil, (1..3)],
      @klass.new(:port => (1..3)).to_a)

    assert_raise(ArgumentError) {
      @klass.new(:port => true)
    }
  end

  def test_initialize__addr_and_name
    assert_raise(ArgumentError) {
      @klass.new(:addr => "127.0.0.1", :name => "localhost")
    }
  end

  def test_initialize__invalid_key
    assert_raise(ArgumentError) {
      @klass.new(:invalid => true)
    }
  end

  #
  # インスタンスメソッド
  #

  def test_value
    assert_raise(NotImplementedError) {
      @klass.new.value
    }
  end

  def test_to_a
    assert_equal(
      [IPAddr.new("0.0.0.0/0"), nil, (0..65535)],
      @klass.new.to_a)
  end
end

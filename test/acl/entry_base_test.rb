
require File.dirname(__FILE__) + "/../test_helper"
require "webhook-dispatcher/acl/entry_base"

class EntryBaseTest < Test::Unit::TestCase
  def setup
    @klass = WebHookDispatcher::Acl::EntryBase
  end

  def test_initialize__default
    entry = @klass.new
    assert_equal(
      [IPAddr.new("0.0.0.0/0"), //, (0..65535)],
      entry.to_a)
  end

  def test_initialize__all
    assert_equal(
      [IPAddr.new("0.0.0.0/0"), //, (0..65535)],
      @klass.new(:all).to_a)
    assert_equal(
      [IPAddr.new("0.0.0.0/0"), //, (0..65535)],
      @klass.new({}).to_a)
  end

  def test_initialize__addr
    assert_equal(
      [IPAddr.new("0.0.0.0/0"), //, (0..65535)],
      @klass.new(:addr => :all).to_a)
    assert_equal(
      [IPAddr.new("127.0.0.1/32"), //, (0..65535)],
      @klass.new(:addr => "127.0.0.1").to_a)
    assert_equal(
      [IPAddr.new("127.0.0.0/8"), //, (0..65535)],
      @klass.new(:addr => IPAddr.new("127.0.0.0/8")).to_a)

    assert_raise(ArgumentError) {
      @klass.new(:addr => :invalid)
    }
  end

  def test_initialize__name
    assert_equal(
      [IPAddr.new("0.0.0.0/0"), //, (0..65535)],
      @klass.new(:name => :all).to_a)
    assert_equal(
      [IPAddr.new("0.0.0.0/0"), "www.google.co.jp", (0..65535)],
      @klass.new(:name => "WWW.GOOGLE.CO.JP").to_a)
    assert_equal(
      [IPAddr.new("0.0.0.0/0"), /google\.co\.jp/, (0..65535)],
      @klass.new(:name => /google\.co\.jp/).to_a)

    assert_raise(ArgumentError) {
      @klass.new(:name => :invalid)
    }
  end

  def test_initialize__port
    assert_equal(
      [IPAddr.new("0.0.0.0/0"), //, (0..65535)],
      @klass.new(:port => :all).to_a)
    assert_equal(
      [IPAddr.new("0.0.0.0/0"), //, [80]],
      @klass.new(:port => 80).to_a)
    assert_equal(
      [IPAddr.new("0.0.0.0/0"), //, [1, 2, 3]],
      @klass.new(:port => [3, 2, 1]).to_a)
    assert_equal(
      [IPAddr.new("0.0.0.0/0"), //, (1..3)],
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

  def test_initialize__invalid_parameter
    assert_raise(ArgumentError) {
      @klass.new(:invalid)
    }
  end

  #
  # インスタンスメソッド
  #

  def test_equal
    assert_equal(true,  (@klass.new == @klass.new))
    assert_equal(false, (@klass.new == nil))
    assert_equal(false, (@klass.new == @klass.new(:addr => "127.0.0.1")))
    assert_equal(false, (@klass.new == @klass.new(:name => "localhost")))
    assert_equal(false, (@klass.new == @klass.new(:port => 80)))
  end

  def test_match__all
    entry = @klass.new
    assert_equal(true, entry.match?(nil, nil, nil))
    assert_equal(true, entry.match?("127.0.0.1", nil, nil))
    assert_equal(true, entry.match?(nil, "localhost", nil))
    assert_equal(true, entry.match?(nil, nil, 80))
  end

  def test_match__addr
    entry = @klass.new(:addr => "127.0.0.0/8")
    assert_equal(false, entry.match?("126.255.255.255", nil, nil))
    assert_equal(true,  entry.match?("127.0.0.0",       nil, nil))
    assert_equal(true,  entry.match?("127.255.255.255", nil, nil))
    assert_equal(false, entry.match?("128.0.0.0",       nil, nil))

    entry = @klass.new(:addr => "127.0.0.1")
    assert_equal(true,  entry.match?("127.0.0.1", "localhost", 80))
    assert_equal(true,  entry.match?("127.0.0.1", "google.co.jp", 8080))
    assert_equal(false, entry.match?("192.168.0.1", "localhost", 443))
  end

  def test_match__name
    entry = @klass.new(:name => "localhost")
    assert_equal(true,  entry.match?(nil, "localhost", nil))
    assert_equal(true,  entry.match?(nil, "LOCALHOST", nil))
    assert_equal(false, entry.match?(nil, "google.co.jp", nil))

    entry = @klass.new(:name => /\.co\.jp$/)
    assert_equal(false, entry.match?(nil, "localhost", nil))
    assert_equal(true,  entry.match?(nil, "google.co.jp", nil))
    assert_equal(true,  entry.match?(nil, "nayutaya.co.jp", nil))

    entry = @klass.new(:name => "localhost")
    assert_equal(true,  entry.match?("127.0.0.1", "localhost", 80))
    assert_equal(false, entry.match?("127.0.0.1", "google.co.jp", 8080))
    assert_equal(true,  entry.match?("192.168.0.1", "localhost", 443))
  end

  def test_match__port
    entry = @klass.new(:port => 80)
    assert_equal(false, entry.match?(nil, nil, 79))
    assert_equal(true,  entry.match?(nil, nil, 80))
    assert_equal(false, entry.match?(nil, nil, 81))
  end

  def test_match__addr_and_port
    entry = @klass.new(:addr => "127.0.0.1", :port => 80)
    assert_equal(true,  entry.match?("127.0.0.1", "localhost", 80))
    assert_equal(true,  entry.match?("127.0.0.1", "google.co.jp", 80))
    assert_equal(false, entry.match?("127.0.0.1", "localhost", 8080))
    assert_equal(false, entry.match?("192.168.0.1", "localhost", 80))
  end

  def test_match_name_and_port
    entry = @klass.new(:name => "localhost", :port => 80)
    assert_equal(true,  entry.match?("127.0.0.1", "localhost", 80))
    assert_equal(false, entry.match?("127.0.0.1", "google.co.jp", 80))
    assert_equal(false, entry.match?("127.0.0.1", "localhost", 8080))
    assert_equal(true,  entry.match?("192.168.0.1", "localhost", 80))
  end

  def test_value
    assert_raise(NotImplementedError) {
      @klass.new.value
    }
  end

  def test_to_a
    assert_equal(
      [IPAddr.new("0.0.0.0/0"), //, (0..65535)],
      @klass.new.to_a)
  end

  def test_match_address?
    entry = @klass.new
    assert_equal(true, entry.instance_eval { match_address?(nil) })
    assert_equal(true, entry.instance_eval { match_address?(IPAddr.new("10.0.0.0")) })
    assert_equal(true, entry.instance_eval { match_address?(IPAddr.new("172.16.0.0")) })
    assert_equal(true, entry.instance_eval { match_address?(IPAddr.new("192.168.0.0")) })

    entry = @klass.new(:addr => "10.0.0.0/8")
    assert_equal(false, entry.instance_eval { match_address?(nil) })
    assert_equal(true,  entry.instance_eval { match_address?(IPAddr.new("10.0.0.0")) })
    assert_equal(false, entry.instance_eval { match_address?(IPAddr.new("172.16.0.0")) })
    assert_equal(false, entry.instance_eval { match_address?(IPAddr.new("192.168.0.0")) })
  end

  def test_match_name?
    entry = @klass.new
    assert_equal(true, entry.instance_eval { match_name?(nil) })
    assert_equal(true, entry.instance_eval { match_name?("localhost") })
    assert_equal(true, entry.instance_eval { match_name?("google.co.jp") })

    entry = @klass.new(:name => "LocalHost")
    assert_equal(false, entry.instance_eval { match_name?(nil) })
    assert_equal(true,  entry.instance_eval { match_name?("localhost") })
    assert_equal(false, entry.instance_eval { match_name?("google.co.jp") })

    entry = @klass.new(:name => /\.co\.jp$/)
    assert_equal(false, entry.instance_eval { match_name?(nil) })
    assert_equal(false, entry.instance_eval { match_name?("localhost") })
    assert_equal(true,  entry.instance_eval { match_name?("google.co.jp") })
  end

  def test_match_port?
    entry = @klass.new
    assert_equal(true, entry.instance_eval { match_port?(nil) })
    assert_equal(true, entry.instance_eval { match_port?(0) })
    assert_equal(true, entry.instance_eval { match_port?(1) })
    assert_equal(true, entry.instance_eval { match_port?(2) })

    entry = @klass.new(:port => 1)
    assert_equal(false, entry.instance_eval { match_port?(nil) })
    assert_equal(false, entry.instance_eval { match_port?(0) })
    assert_equal(true,  entry.instance_eval { match_port?(1) })
    assert_equal(false, entry.instance_eval { match_port?(2) })

    entry = @klass.new(:port => [0, 1])
    assert_equal(false, entry.instance_eval { match_port?(nil) })
    assert_equal(true,  entry.instance_eval { match_port?(0) })
    assert_equal(true,  entry.instance_eval { match_port?(1) })
    assert_equal(false, entry.instance_eval { match_port?(2) })

    entry = @klass.new(:port => 1..2)
    assert_equal(false, entry.instance_eval { match_port?(nil) })
    assert_equal(false, entry.instance_eval { match_port?(0) })
    assert_equal(true,  entry.instance_eval { match_port?(1) })
    assert_equal(true,  entry.instance_eval { match_port?(2) })
  end
end

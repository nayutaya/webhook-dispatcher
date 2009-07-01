
require File.dirname(__FILE__) + "/../test_helper"
require "webhook-dispatcher/acl/entry_base"

class EntryBaseTest < Test::Unit::TestCase
  def setup
    @klass = WebHookDispatcher::Acl::EntryBase
  end

  def test_initialize1
    entry = @klass.new
    assert_equal(IPAddr.new("0.0.0.0/0"), entry.addr)
    assert_equal(nil, entry.name)
    assert_equal((0..65535), entry.port)
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

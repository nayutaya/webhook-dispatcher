
require File.dirname(__FILE__) + "/../test_helper"
require "webhook-dispatcher/acl/allow_entry"

class AllowEntryTest < Test::Unit::TestCase
  def setup
    @klass = WebHookDispatcher::Acl::AllowEntry
  end

  #
  # インスタンスメソッド
  #

  def test_value
    assert_equal(true, @klass.new.value)
  end
end


require File.dirname(__FILE__) + "/../test_helper"
require "webhook-dispatcher/acl/deny_entry"

class DenyEntryTest < Test::Unit::TestCase
  def setup
    @klass = WebHookDispatcher::Acl::DenyEntry
  end

  def test_value
    assert_equal(false, @klass.new.value)
  end
end

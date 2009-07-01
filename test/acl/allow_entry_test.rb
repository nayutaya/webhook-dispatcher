
require File.dirname(__FILE__) + "/../test_helper"
require "webhook-dispatcher/acl/allow_entry"

class AllowEntryTest < Test::Unit::TestCase
  def setup
    @klass = WebHookDispatcher::Acl::AllowEntry
  end

  def test_ok
    assert true
  end
end

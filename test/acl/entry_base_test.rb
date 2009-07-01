
require File.dirname(__FILE__) + "/../test_helper"
require "webhook-dispatcher/acl/entry_base"

class EntryBaseTest < Test::Unit::TestCase
  def setup
    @klass = WebHookDispatcher::Acl::EntryBase
  end

  def test_ok
    assert true
  end
end

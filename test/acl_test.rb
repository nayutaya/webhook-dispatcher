
require "test_helper"

$:.unshift("../lib")
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

  def test_size
    assert_equal(0, @acl.size)
  end
end

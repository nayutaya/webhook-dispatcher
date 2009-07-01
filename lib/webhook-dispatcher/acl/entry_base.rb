
require "ipaddr"

class WebHookDispatcher
  class Acl
    class EntryBase
    end
  end
end

class WebHookDispatcher::Acl::EntryBase
  def initialize
    @addr = IPAddr.new("0.0.0.0/0")
    @name = nil
    @port = 0..65535
  end

  attr_reader :addr, :name, :port

  def value
    raise(NotImplementedError)
  end

  def to_a
    return [@addr, @name, @port]
  end
end

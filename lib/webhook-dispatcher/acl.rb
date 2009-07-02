
require "ipaddr"
require "webhook-dispatcher/acl/allow_entry"
require "webhook-dispatcher/acl/deny_entry"

class WebHookDispatcher::Acl
  def initialize
    @entries = []
  end

  def self.with(&block)
    return self.new.with(&block)
  end

  def self.allow_all
    return self.with { allow :all }
  end

  def self.deny_all
    return self.with { deny :all }
  end
  
  def self.ipaddr?(value)
    return true if value.instance_of?(IPAddr)
    begin
      IPAddr.new(value)
      return true
    rescue ArgumentError
      return false
    end
  end

  def self.create_matching_targets(addr_or_name, port)
    if self.ipaddr?(addr_or_name)
      addr = addr_or_name
      return [[IPAddr.new(addr), nil, port]]
    else
      name = addr_or_name
      _name, _aliases, _type, *addresses = TCPSocket.gethostbyname(name)
      return addresses.map { |addr| [IPAddr.new(addr), name, port] }
    end
  end

  def ==(other)
    return false unless other.instance_of?(self.class)
    return (@entries == other.instance_eval { @entries })
  end

  def size
    return @entries.size
  end

  def add_allow(options)
    @entries << AllowEntry.new(options)
    return self
  end

  def add_deny(options)
    @entries << DenyEntry.new(options)
    return self
  end

  def with(&block)
    raise(ArgumentError) unless block_given?

    obj = Object.new

    this = self
    (class << obj; self; end).class_eval {
      define_method(:allow) { |options| this.add_allow(options) }
      define_method(:deny)  { |options| this.add_deny(options) }
      private :allow, :deny
    }

    obj.instance_eval(&block)

    return self
  end

  def allow?(addr_or_name, port = nil)
    targets = self.class.create_matching_targets(addr_or_name, port)

    return targets.all? { |taddr, tname, tport|
      @entries.inject(true) { |result, entry|
        result = entry.value if entry.match?(taddr, tname, tport)
        result
      }
    }
  end

  def deny?(addr_or_name, port = nil)
    return !self.allow?(addr_or_name, port)
  end
end

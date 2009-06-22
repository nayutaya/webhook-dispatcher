
require "ipaddr"

class WebHookPublisher::Acl
  def initialize
    @records = []
  end

  def size
    return @records.size
  end

  def add_allow(ipaddr)
    @records << AllowRecord.new(ipaddr)
    return self
  end

  def add_deny(ipaddr)
    @records << DenyRecord.new(ipaddr)
    return self
  end

  def with(&block)
    raise(ArgumentError) unless block_given?

    obj = Object.new

    this = self
    (class << obj; self; end).class_eval {
      define_method(:allow) { |ipaddr| this.add_allow(ipaddr) }
      define_method(:deny)  { |ipaddr| this.add_deny(ipaddr) }
      private :allow, :deny
    }

    obj.instance_eval(&block)

    return self
  end

  def allow?(ipaddr)
    return @records.inject(true) { |result, record|
      result = record.value if record.include?(ipaddr)
      result
    }
  end

  def deny?(ipaddr)
    return !self.allow?(ipaddr)
  end

  class RecordBase
    def initialize(ipaddr)
      @ipaddr =
        case ipaddr
        when :all   then IPAddr.new("0.0.0.0/0")
        when String then IPAddr.new(ipaddr)
        when IPAddr then ipaddr
        else raise(ArgumentError, "invalid IP address")
        end
    end

    attr_reader :ipaddr

    def include?(ipaddr)
      return @ipaddr.include?(ipaddr)
    end
  end

  class AllowRecord < RecordBase
    def value
      return true
    end
  end

  class DenyRecord < RecordBase
    def value
      return false
    end
  end
end

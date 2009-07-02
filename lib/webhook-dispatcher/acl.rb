
require "ipaddr"
require "webhook-dispatcher/acl/allow_entry"
require "webhook-dispatcher/acl/deny_entry"

# TODO: ポート番号によるアクセス制御
class WebHookDispatcher::Acl
  def initialize
    @records = []
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

  def ==(other)
    return false unless other.instance_of?(self.class)
    return (@records == other.instance_eval { @records })
  end

  def size
    return @records.size
  end

  def add_allow(options)
    @records << AllowEntry.new(options)
    return self
  end

  def add_deny(options)
    @records << DenyEntry.new(options)
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

  def allow?(ipaddr)
    return @records.inject(true) { |result, record|
      result = record.value if record.match?(ipaddr, nil, nil)
      result
    }
  end

  def deny?(ipaddr)
    return !self.allow?(ipaddr)
  end

=begin
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

    def ==(other)
      return false unless other.instance_of?(self.class)
      return (self.ipaddr == other.ipaddr)
    end

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
=end
end


require "ipaddr"
require "webhook-dispatcher/acl/allow_entry"
require "webhook-dispatcher/acl/deny_entry"

# TODO: ポート番号によるアクセス制御
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

  def allow?(ipaddr)
    return @entries.inject(true) { |result, record|
      result = record.value if record.match?(ipaddr, nil, nil)
      result
    }
  end

  def deny?(ipaddr)
    return !self.allow?(ipaddr)
  end
end

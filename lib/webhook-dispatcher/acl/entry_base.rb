
require "ipaddr"

class WebHookDispatcher
  class Acl
    class EntryBase
    end
  end
end

class WebHookDispatcher::Acl::EntryBase
  def initialize(options = :all)
    @addr = IPAddr.new("0.0.0.0/0")
    @name = nil
    @port = 0..65535

    case options
    when :all
      # nop
    when {}
      # nop
    when Hash
      options = options.dup
      addr = options.delete(:addr)
      name = options.delete(:name)

      if addr
        @addr = normalize_addr(addr)
        @name = nil
      elsif name
        @addr = nil
        @name = normalize_name(name)
      else
        #raise(ArgumentError)
      end
    end
  end

  attr_reader :addr, :name, :port

  def value
    raise(NotImplementedError)
  end

  def to_a
    return [@addr, @name, @port]
  end

  private

  def normalize_addr(addr)
    case addr
    when :all   then return IPAddr.new("0.0.0.0/0")
    when String then return IPAddr.new(addr)
    when IPAddr then return addr
    else raise(ArgumentError)
    end
  end

  def normalize_name(name)
    case name
    when String then name.downcase
    when Regexp then name
    else raise(ArgumentError)
    end
  end
end

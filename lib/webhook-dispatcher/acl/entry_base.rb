
require "ipaddr"

class WebHookDispatcher
  class Acl
    class EntryBase
    end
  end
end

class WebHookDispatcher::Acl::EntryBase
  AnyAddress   = IPAddr.new("0.0.0.0/0")
  TcpPortRange = 0..65535

  def initialize(options = :all)
    case options
    when :all, {}
      @addr = AnyAddress
      @name = nil
      @port = TcpPortRange
    when Hash
      options = options.dup
      addr = options.delete(:addr)
      name = options.delete(:name)
      port = options.delete(:port) || :all
      raise(ArgumentError) unless options.empty?

      @addr, @name =
        case [addr, name].map(&:nil?)
        when [false, true ] then [normalize_addr(addr), nil]
        when [true , false] then [nil, normalize_name(name)]
        when [true , true ] then [AnyAddress, nil]
        else raise(ArgumentError)
        end
      @port = normalize_port(port)
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
    when :all   then return AnyAddress
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

  def normalize_port(port)
    case port
    when :all    then TcpPortRange
    when Integer then [port]
    when Array   then port.sort
    when Range   then port
    else raise(ArgumentError)
    end
  end
end

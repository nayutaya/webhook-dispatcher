
require "ipaddr"

class WebHookDispatcher
  class Acl
    class EntryBase
    end
  end
end

class WebHookDispatcher::Acl::EntryBase
  def initialize(options = nil)
    case options
    when nil, :all
      @addr = nil
      @name = nil
      @port = nil
    when Hash
      options = options.dup
      @addr = normalize_addr(options.delete(:addr))
      @name = normalize_name(options.delete(:name))
      @port = normalize_port(options.delete(:port))
      raise(ArgumentError) unless options.empty?
    else raise(ArgumentError)
    end
  end

  attr_reader :addr, :name, :port

  def ==(other)
    return false unless other.instance_of?(self.class)
    return (self.to_a == other.to_a)
  end

  def match?(addr, name, port)
    return match_addr?(addr) && match_name?(name) && match_port?(port)
  end

  def value
    raise(NotImplementedError)
  end

  def to_a
    return [@addr, @name, @port]
  end

  private

  def normalize_addr(addr)
    case addr
    when nil    then return nil
    when :all   then return nil
    when String then return IPAddr.new(addr)
    when IPAddr then return addr
    else raise(ArgumentError)
    end
  end

  def normalize_name(name)
    case name
    when nil    then return nil
    when :all   then return nil
    when String then return name.downcase
    when Regexp then return name
    else raise(ArgumentError)
    end
  end

  def normalize_port(port)
    case port
    when nil     then return nil
    when :all    then return nil
    when Integer then return [port]
    when Array   then return port.sort
    when Range   then return port
    else raise(ArgumentError)
    end
  end

  def match_addr?(addr)
    return true if self.addr.nil?
    return (!addr.nil? && self.addr.include?(addr))
  end

  def match_name?(name)
    return true if self.name.nil?
    return (!name.nil? && (self.name === name.downcase))
  end

  def match_port?(port)
    return true if self.port.nil?
    return (!port.nil? && self.port.include?(port))
  end
end

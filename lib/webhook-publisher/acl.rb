
require "ipaddr"

class WebHookPublisher::Acl
  def initialize
    @list = []
  end

  def size
    return @list.size
  end

  def add_allow(ipaddr)
    @list << [:allow, ipaddr]
    return self
  end

  def add_deny(ipaddr)
    @list << [:deny, ipaddr]
    return self
  end

  def allow?(ipaddr)
    result = true

    @list.each { |type, network|
      if network.include?(ipaddr)
        result =
          case type
          when :allow then true
          when :deny  then false
          else raise("BUG")
          end
      end
    }

    return result
  end
end

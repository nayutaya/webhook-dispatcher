
class WebHookDispatcher
  @open_timeout = nil
  @read_timeout = nil
  @user_agent   = nil

  def self.open_timeout
    return @open_timeout
  end

  def self.open_timeout=(sec)
    @open_timeout = sec
  end

  def self.read_timeout
    return @read_timeout
  end

  def self.read_timeout=(sec)
    @read_timeout = sec
  end

  def self.user_agent
    return nil
  end

  def self.user_agent=(value)
    @user_agent = value
  end
end

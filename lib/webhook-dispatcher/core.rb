
class WebHookDispatcher
  @open_timeout = nil
  @read_timeout = nil
  @user_agent   = nil

  def initialize
    @open_timeout = nil
    @read_timeout = nil
    @user_agent   = nil
  end

  class << self
    attr_accessor :open_timeout, :read_timeout, :user_agent
  end

  attr_accessor :open_timeout, :read_timeout, :user_agent
end

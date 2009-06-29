
require "webhook-dispatcher/version"

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

  def self.default_open_timeout
    return 10
  end

  def self.default_read_timeout
    return 10
  end

  def self.default_user_agent
    return "webhook-dispatcher #{self::VERSION}"
  end

  attr_accessor :open_timeout, :read_timeout, :user_agent
end

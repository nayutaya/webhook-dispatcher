
require "webhook-dispatcher/version"

class WebHookDispatcher
  @open_timeout = nil
  @read_timeout = nil
  @user_agent   = nil

  def initialize(options = {})
    options = options.dup
    @open_timeout = options.delete(:open_timeout) || self.class.open_timeout || self.class.default_open_timeout
    @read_timeout = options.delete(:read_timeout) || self.class.read_timeout || self.class.default_read_timeout
    @user_agent   = options.delete(:user_agent)   || self.class.user_agent   || self.class.default_user_agent
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

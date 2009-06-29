
require "webhook-dispatcher/version"

class WebHookDispatcher
  def initialize(options = {})
    options = options.dup
    @open_timeout = options.delete(:open_timeout) || self.class.open_timeout || self.class.default_open_timeout
    @read_timeout = options.delete(:read_timeout) || self.class.read_timeout || self.class.default_read_timeout
    @user_agent   = options.delete(:user_agent)   || self.class.user_agent   || self.class.default_user_agent
  end

  class << self
    @open_timeout = nil
    @read_timeout = nil
    @user_agent   = nil
    attr_accessor :open_timeout, :read_timeout, :user_agent
    define_method(:default_open_timeout) { 10 }
    define_method(:default_read_timeout) { 10 }
    define_method(:default_user_agent)   { "webhook-dispatcher #{self::VERSION}" }
  end

  attr_accessor :open_timeout, :read_timeout, :user_agent
end

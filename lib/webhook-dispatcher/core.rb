
require "net/http"
require "webhook-dispatcher/version"
require "webhook-dispatcher/acl"

class WebHookDispatcher
  def initialize(options = {})
    options = options.dup
    @open_timeout = options.delete(:open_timeout) || self.class.open_timeout || self.class.default_open_timeout
    @read_timeout = options.delete(:read_timeout) || self.class.read_timeout || self.class.default_read_timeout
    @user_agent   = options.delete(:user_agent)   || self.class.user_agent   || self.class.default_user_agent
    @acl          = options.delete(:acl)          || self.class.acl          || self.class.default_acl
    raise(ArgumentError, "invalid parameter") unless options.empty?
  end

  class << self
    @open_timeout = nil
    @read_timeout = nil
    @user_agent   = nil
    @acl          = nil

    attr_accessor :open_timeout, :read_timeout, :user_agent, :acl

    define_method(:default_open_timeout) { 10 }
    define_method(:default_read_timeout) { 10 }
    define_method(:default_user_agent)   { "webhook-dispatcher #{self::VERSION}" }
    define_method(:default_acl)          { Acl.new }

    def acl_with(&block)
      self.acl = Acl.with(&block)
    end
  end

  attr_accessor :open_timeout, :read_timeout, :user_agent, :acl

  def acl_with(&block)
    self.acl = Acl.with(&block)
  end

  private

  def setup_http_connector(http_conn)
    http_conn.open_timeout = self.open_timeout
    http_conn.read_timeout = self.read_timeout
    return http_conn
  end

  def setup_http_request(http_request)
    http_request["User-Agent"] = self.user_agent
    http_request
  end
end

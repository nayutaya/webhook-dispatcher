
require "net/http"
require "webhook-dispatcher/version"
require "webhook-dispatcher/acl"
require "webhook-dispatcher/request/get"
require "webhook-dispatcher/request/head"
require "webhook-dispatcher/request/post"
require "webhook-dispatcher/response"

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

  def request(request)
    http_conn = request.create_http_connector
    http_req  = request.create_http_request
    setup_http_connector(http_conn)
    setup_http_request(http_req)

    # TODO: アクセス制御リスト（ACL）による制御

    begin
      http_res = http_conn.start { http_conn.request(http_req) }

      return Response.new(
        :status    => (http_res.kind_of?(Net::HTTPSuccess) ? :success : :failure),
        :http_code => http_res.code.to_i,
        :message   => http_res.message)
    rescue TimeoutError => e
      return Response.new(
        :status    => :timeout,
        :message   => "timeout.",
        :exception => e)
    rescue Errno::ECONNREFUSED => e
      return Response.new(
        :status    => :refused,
        :message   => "connection refused.",
        :exception => e)
    rescue Errno::ECONNRESET => e
      return Response.new(
        :status    => :reset,
        :message   => "connection reset by peer.",
        :exception => e)
    rescue => e
      return Response.new(
        :status    => :error,
        :message   => "#{e.class}: #{e.message}",
        :exception => e)
    end
  end

  def get(uri)
    return self.request(Request::Get.new(uri))
  end

  def head(uri)
    return self.request(Request::Head.new(uri))
  end

  def post(uri, body = nil)
    return self.request(Request::Post.new(uri, body))
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


require File.dirname(__FILE__) + "/test_helper"
require "webhook-dispatcher/core"

class CoreTest < Test::Unit::TestCase
  def setup
    @klass = WebHookDispatcher
    @dispatcher = @klass.new

    @real_access = true
    @example_jp  = URI.parse("http://example.jp/")
    @get_request = @klass::Request::Get.new(@example_jp)
    @http_musha  = Kagemusha.new(Net::HTTP)
  end

  #
  # 初期化
  #

  def test_initialize__global_default
    @klass.open_timeout = nil
    @klass.read_timeout = nil
    @klass.user_agent   = nil
    @klass.acl          = nil

    dispatcher = @klass.new
    assert_equal(@klass.default_open_timeout, dispatcher.open_timeout)
    assert_equal(@klass.default_read_timeout, dispatcher.read_timeout)
    assert_equal(@klass.default_user_agent,   dispatcher.user_agent)
    assert_equal(@klass.default_acl,          dispatcher.acl)
  end

  def test_initialize__class_default
    @klass.open_timeout = 1
    @klass.read_timeout = 2
    @klass.user_agent   = "3"
    @klass.acl          = @klass::Acl.allow_all

    dispatcher = @klass.new
    assert_equal(1,   dispatcher.open_timeout)
    assert_equal(2,   dispatcher.read_timeout)
    assert_equal("3", dispatcher.user_agent)
    assert_equal(@klass::Acl.allow_all, dispatcher.acl)
  end

  def test_initialize__parameter
    @klass.open_timeout = 1
    @klass.read_timeout = 2
    @klass.user_agent   = "3"
    @klass.acl          = @klass::Acl.allow_all

    dispatcher = @klass.new(
      :open_timeout => 4,
      :read_timeout => 5,
      :user_agent   => "6",
      :acl          => @klass::Acl.deny_all)
    assert_equal(4,   dispatcher.open_timeout)
    assert_equal(5,   dispatcher.read_timeout)
    assert_equal("6", dispatcher.user_agent)
    assert_equal(@klass::Acl.deny_all, dispatcher.acl)
  end

  def test_initialize__invalid_parameter
    assert_raise(ArgumentError) {
      @klass.new(:invalid => true)
    }
  end

  #
  # クラスメソッド
  #

  def test_self_open_timeout
    @klass.open_timeout = 5
    assert_equal(5, @klass.open_timeout)
  end

  def test_self_read_timeout
    @klass.read_timeout = 5
    assert_equal(5, @klass.read_timeout)
  end

  def test_self_user_agent
    @klass.user_agent = "ie"
    assert_equal("ie", @klass.user_agent)
  end

  def test_self_acl
    @klass.acl = @klass::Acl.new
    assert_equal(@klass::Acl.new, @klass.acl)
  end

  def test_self_default_open_timeout
    assert_equal(10, @klass.default_open_timeout)
  end

  def test_self_default_read_timeout
    assert_equal(10, @klass.default_read_timeout)
  end

  def test_self_default_user_agent
    assert_equal(
      "webhook-dispatcher #{@klass::VERSION}",
      @klass.default_user_agent)
  end

  def test_self_default_acl
    assert_equal(@klass::Acl.new, @klass.default_acl)
  end

  def test_self_acl_with
    @klass.acl_with {
      allow :all
    }
    assert_equal(@klass::Acl.allow_all, @klass.acl)
  end

  #
  # インスタンスメソッド
  #

  def test_open_timeout
    @dispatcher.open_timeout = 10
    assert_equal(10, @dispatcher.open_timeout)
  end

  def test_read_timeout
    @dispatcher.read_timeout = 10
    assert_equal(10, @dispatcher.read_timeout)
  end

  def test_user_agent
    @dispatcher.user_agent = "firefox"
    assert_equal("firefox", @dispatcher.user_agent)
  end

  def test_acl
    @dispatcher.acl = @klass::Acl.new
    assert_equal(@klass::Acl.new, @dispatcher.acl)
  end

  def test_acl_with
    @dispatcher.acl_with {
      allow :all
    }
    assert_equal(@klass::Acl.allow_all, @dispatcher.acl)
  end

  def test_request__200_ok
    @http_musha.def(:start) { Net::HTTPOK.new("1.1", "200", "OK") }

    response = @http_musha.swap { @dispatcher.request(@get_request) }
    assert_equal(true,     response.success?)
    assert_equal(:success, response.status)
    assert_equal(200,      response.http_code)

    assert_equal("OK", response.message)
    assert_equal(nil, response.exception)
  end

  def test_request__201_created
    @http_musha.def(:start) { Net::HTTPCreated.new("1.1", "201", "Created") }

    response = @http_musha.swap { @dispatcher.request(@get_request) }
    assert_equal(true,     response.success?)
    assert_equal(:success, response.status)
    assert_equal(201,      response.http_code)

    assert_equal("Created", response.message)
    assert_equal(nil, response.exception)
  end

  def test_request__301_moved_permanently
    @http_musha.def(:start) { Net::HTTPMovedPermanently.new("1.1", "301", "Moved Permanently") }

    response = @http_musha.swap { @dispatcher.request(@get_request) }
    assert_equal(false,    response.success?)
    assert_equal(:failure, response.status)
    assert_equal(301,      response.http_code)

    assert_equal("Moved Permanently", response.message)
    assert_equal(nil, response.exception)
  end

  # TODO: 許可されていないホストに対するHTTPリクエストのテスト

  def test_request__timeout
    @http_musha.def(:start) { raise(TimeoutError) }

    response = @http_musha.swap { @dispatcher.request(@get_request) }
    assert_equal(false,    response.success?)
    assert_equal(:timeout, response.status)
    assert_equal(nil,      response.http_code)

    assert_equal("timeout.", response.message)
    assert_kind_of(TimeoutError, response.exception)
  end

  def test_request__refused
    @http_musha.def(:start) { raise(Errno::ECONNREFUSED) }

    response = @http_musha.swap { @dispatcher.request(@get_request) }
    assert_equal(false,    response.success?)
    assert_equal(:refused, response.status)
    assert_equal(nil,      response.http_code)

    assert_equal("connection refused.", response.message)
    assert_kind_of(Errno::ECONNREFUSED, response.exception)
  end

  def test_request__reset
    @http_musha.def(:start) { raise(Errno::ECONNRESET) }

    response = @http_musha.swap { @dispatcher.request(@get_request) }
    assert_equal(false,  response.success?)
    assert_equal(:reset, response.status)
    assert_equal(nil,    response.http_code)

    assert_equal("connection reset by peer.", response.message)
    assert_kind_of(Errno::ECONNRESET, response.exception)
  end

  def test_request__other_error
    @http_musha.def(:start) { raise(SocketError, "message.") }

    response = @http_musha.swap { @dispatcher.request(@get_request) }
    assert_equal(false,  response.success?)
    assert_equal(:error, response.status)
    assert_equal(nil,    response.http_code)

    assert_equal("SocketError: message.", response.message)
    assert_kind_of(SocketError, response.exception)
  end

  def test_get
    request = nil
    musha = Kagemusha.new(@klass)
    musha.def(:request) { |req| request = req; :ok }
    musha.swap {
      assert_equal(:ok, @dispatcher.get(@example_jp))
    }
    assert_kind_of(@klass::Request::Get, request)
    assert_equal(@example_jp, request.uri)
  end

  def test_get__request_to_google
    if @real_access
      res = @dispatcher.get(URI.parse("http://www.google.co.jp/"))
      assert_equal(true,     res.success?)
      assert_equal(:success, res.status)
      assert_equal(200,      res.http_code)
      assert_equal("OK",     res.message)
      assert_equal(nil,      res.exception)
    end
  end

  def test_head
    request = nil
    musha = Kagemusha.new(@klass)
    musha.def(:request) { |req| request = req; :ok }
    musha.swap {
      assert_equal(:ok, @dispatcher.head(@example_jp))
    }
    assert_kind_of(@klass::Request::Head, request)
    assert_equal(@example_jp, request.uri)
  end

  def test_head__request_to_google
    if @real_access
      res = @dispatcher.head(URI.parse("http://www.google.co.jp/"))
      assert_equal(true,     res.success?)
      assert_equal(:success, res.status)
      assert_equal(200,      res.http_code)
      assert_equal("OK",     res.message)
      assert_equal(nil,      res.exception)
    end
  end

  def test_post
    request = nil
    musha = Kagemusha.new(@klass)
    musha.def(:request) { |req| request = req; :ok }
    musha.swap {
      assert_equal(:ok, @dispatcher.post(@example_jp, "body"))
    }
    assert_kind_of(@klass::Request::Post, request)
    assert_equal(@example_jp, request.uri)
    assert_equal("body",      request.body)
  end

  def test_post__request_to_google
    if @real_access
      res = @dispatcher.post(URI.parse("http://www.google.co.jp/"), "")
      assert_equal(false,    res.success?)
      assert_equal(:failure, res.status)
      assert_equal(405,      res.http_code)
      assert_equal("Method Not Allowed", res.message)
      assert_equal(nil,      res.exception)
    end
  end

  def test_setup_http_connector
    conn = Net::HTTP.new("example.jp")
    assert_equal(nil, conn.open_timeout)
    assert_equal(60,  conn.read_timeout)

    @dispatcher.open_timeout = 10
    @dispatcher.read_timeout = 20
    @dispatcher.instance_eval { setup_http_connector(conn) }
    assert_equal(10, conn.open_timeout)
    assert_equal(20, conn.read_timeout)
  end

  def test_setup_http_request
    req = Net::HTTP::Get.new("/")
    assert_equal(nil, req["User-Agent"])

    @dispatcher.user_agent = "safari"
    @dispatcher.instance_eval { setup_http_request(req) }
    assert_equal("safari", req["User-Agent"])
  end
end

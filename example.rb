
# このスクリプトはイメージであり、動作しません

WebHookPublisher.open_timeout = 5 # sec
WebHookPublisher.read_timeout = 5 # sec
WebHookPublisher.user_agent = "hoge"
WebHookPublisher.acl = x
WebHookPublisher.acl_with {
}

wp = WebHookPublisher.new
wp.open_timeout = 5 # sec
wp.read_timeout = 5 # sec
wp.user_agent = "hoge"
wp.acl = WebHookPublisher::Acl.with {
  allow :all
  allow "*", :all
  allow "*", 1024..3000
  allow "*", 0..1024
  allow "*", [1,2,3,4]
  deny IPAdd.new("0.0.0.0/0")
  allow "127.0.0.0/8"
  allow "localhost"
}

acl.clear
acl.add_deny(...)
acl.add_allow(...)
acl.allow?(ipaddr)
acl.deny?(ipaddr)
acl.with { ... }


request_obj = WebHookPublisher::Request.new(:get, URI.new(..))
request_obj.http_method = :get
request_obj.uri = uri

res = wp.request(request_obj)
res = wp.get(url)
res = wp.head(url)
res = wp.post(url, data)
#=> WebHookPublisher::Response
res.success? #=> true/false
res.status #=> :timeout
res.status_code #=> 200
res.status_message #=> OK
res.inner_exception #=> #<RuntimeError>

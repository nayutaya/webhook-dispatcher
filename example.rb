
# このスクリプトはイメージであり、動作しません

WebHookPublisher.acl = x
WebHookPublisher.acl_with {
}

wp = WebHookPublisher.new
wp.open_timeout = 5 # sec
wp.read_timeout = 5 # sec
wp.user_agent = "hoge"
wp.acl = WebHookPublisher::Acl.with {
  #..
}

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

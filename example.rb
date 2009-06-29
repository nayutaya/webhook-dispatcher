
# このスクリプトはイメージであり、動作しません

request_obj = WebHookPublisher::Request.new(:get, URI.new(..))
request_obj.http_method = :get
request_obj.uri = uri

res = wp.request(request_obj)
res = wp.get(url)
res = wp.head(url)
res = wp.post(url, data)
#=> WebHookPublisher::Response

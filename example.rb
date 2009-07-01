
# このスクリプトはイメージであり、動作しません

require "webhook-dispatcher"

p dispatcher = WebHookDispatcher.new
p request = WebHookDispatcher::Request::Get.new(URI.parse("http://www.google.co.jp"))

p response = dispatcher.request(request)

=begin
res = wp.request(request_obj)
res = wp.get(url)
res = wp.head(url)
res = wp.post(url, data)
#=> WebHookPublisher::Response
=end

acl.with {
  allow :host => "www.google.co.jp"
  deny :host => /google\.co\.jp$/
  allow :port => 1..10
  deny :port => [1,2,3,4]
}
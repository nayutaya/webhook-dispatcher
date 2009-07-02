
Gem::Specification.new do |s|
  s.specification_version     = 2
  s.required_rubygems_version = Gem::Requirement.new(">= 0")
  s.required_ruby_version     = Gem::Requirement.new(">= 1.8.6")

  s.name    = "webhook-dispatcher"
  s.version = "0.0.2"
  s.date    = "2009-07-02"

  s.authors = ["Yuya Kato"]
  s.email   = "yuyakato@gmail.com"

  s.summary     = "webhook-dispatcher"
  s.description = "webhook-dispatcher"
  s.homepage    = "http://github.com/nayutaya/webhook-dispatcher/"

  s.rubyforge_project = nil
  s.has_rdoc          = false
  s.require_paths     = ["lib"]

  s.files = [
    "README.ja",
    "Rakefile",
    "example.rb",
    "lib/webhook-dispatcher.rb",
    "lib/webhook-dispatcher/acl.rb",
    "lib/webhook-dispatcher/acl/allow_entry.rb",
    "lib/webhook-dispatcher/acl/deny_entry.rb",
    "lib/webhook-dispatcher/acl/entry_base.rb",
    "lib/webhook-dispatcher/core.rb",
    "lib/webhook-dispatcher/request/base.rb",
    "lib/webhook-dispatcher/request/get.rb",
    "lib/webhook-dispatcher/request/head.rb",
    "lib/webhook-dispatcher/request/post.rb",
    "lib/webhook-dispatcher/response.rb",
    "lib/webhook-dispatcher/version.rb",
    "test/acl/allow_entry_test.rb",
    "test/acl/deny_entry_test.rb",
    "test/acl/entry_base_test.rb",
    "test/acl_test.rb",
    "test/core_test.rb",
    "test/request/base_test.rb",
    "test/request/get_test.rb",
    "test/request/head_test.rb",
    "test/request/post_test.rb",
    "test/response_test.rb",
    "test/test_helper.rb",
    "webhook-dispatcher.gemspec",
    "webhook-dispatcher.gemspec.erb",
  ]
  s.test_files = [
    "test/acl_test.rb",
    "test/core_test.rb",
    "test/response_test.rb",
    "test/test_helper.rb",
  ]
  s.extra_rdoc_files = []
end

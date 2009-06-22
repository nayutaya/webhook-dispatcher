
Gem::Specification.new do |s|
  s.specification_version     = 2
  s.required_rubygems_version = Gem::Requirement.new(">= 0")
  s.required_ruby_version     = Gem::Requirement.new(">= 1.8.6")

  s.name    = "webhook-publisher"
  s.version = "0.0.0"
  s.date    = "2009-06-23"

  s.authors = ["Yuya Kato"]
  s.email   = "yuyakato@gmail.com"

  s.summary     = "webhook-publisher"
  s.description = "webhook-publisher"
  s.homepage    = "http://github.com/nayutaya/webhook-publisher/"

  s.rubyforge_project = nil
  s.has_rdoc          = false
  s.require_paths     = ["lib"]

  s.files = [
    "example.rb",
    "lib/webhook-publisher/acl.rb",
    "lib/webhook-publisher/core.rb",
    "lib/webhook-publisher/request/base.rb",
    "lib/webhook-publisher/response.rb",
    "lib/webhook-publisher/version.rb",
    "lib/webhook-publisher.rb",
    "Rakefile",
    "README.ja",
    "test/acl_test.rb",
    "test/request_base.rb",
    "test/response_test.rb",
    "test/test_helper.rb",
    "webhook-publisher.gemspec",
    "webhook-publisher.gemspec.erb",
  ]
  s.test_files = [
    "test/acl_test.rb",
    "test/request_base.rb",
    "test/response_test.rb",
    "test/test_helper.rb",
  ]
  s.extra_rdoc_files = [
    "README.ja",
  ]
end

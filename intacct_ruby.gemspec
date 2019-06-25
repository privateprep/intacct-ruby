# -*- encoding: utf-8 -*-
# stub: intacct_ruby 2.0.0 ruby lib

Gem::Specification.new do |s|
  s.name = "intacct_ruby".freeze
  s.version = "2.0.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Jeremy Zornow".freeze, "Dan Powell".freeze]
  s.bindir = "exe".freeze
  s.date = "2019-06-25"
  s.description = "Allows for multi-function API calls, the addition of custom fields, and more. All in an easy-to-use package!".freeze
  s.email = ["jeremy@zornow.com".freeze, "dan.powell@privateprep.com".freeze]
  s.files = [".github/ISSUE_TEMPLATE.md".freeze, ".github/PULL_REQUEST_TEMPLATE.md".freeze, ".gitignore".freeze, ".rspec".freeze, ".travis.yml".freeze, "CHANGELOG.md".freeze, "CODE_OF_CONDUCT.md".freeze, "Gemfile".freeze, "LICENSE.txt".freeze, "README.md".freeze, "Rakefile".freeze, "bin/console".freeze, "bin/setup".freeze, "intacct_ruby.gemspec".freeze, "lib/intacct_ruby.rb".freeze, "lib/intacct_ruby/api.rb".freeze, "lib/intacct_ruby/exceptions/empty_request_exception.rb".freeze, "lib/intacct_ruby/exceptions/function_failure_exception.rb".freeze, "lib/intacct_ruby/exceptions/insufficient_credentials_exception.rb".freeze, "lib/intacct_ruby/exceptions/unknown_function_type.rb".freeze, "lib/intacct_ruby/function.rb".freeze, "lib/intacct_ruby/request.rb".freeze, "lib/intacct_ruby/response.rb".freeze, "lib/intacct_ruby/version.rb".freeze]
  s.homepage = "https://github.com/privateprep/intacct-ruby".freeze
  s.licenses = ["MIT".freeze]
  s.required_ruby_version = Gem::Requirement.new(">= 2.2.0".freeze)
  s.rubygems_version = "2.7.9".freeze
  s.summary = "A Ruby wrapper for the Intacct API".freeze

  s.installed_by_version = "2.7.9" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<bundler>.freeze, ["~> 1.13"])
      s.add_development_dependency(%q<nokogiri>.freeze, ["~> 1.6", ">= 1.6.8"])
      s.add_development_dependency(%q<mocha>.freeze, ["~> 0.13.3"])
      s.add_development_dependency(%q<pry-byebug>.freeze, ["~> 3.4", ">= 3.4.2"])
      s.add_development_dependency(%q<rake>.freeze, ["~> 10.0"])
      s.add_development_dependency(%q<rspec>.freeze, ["~> 3.0"])
      s.add_development_dependency(%q<travis>.freeze, ["~> 1.8", ">= 1.8.8"])
      s.add_runtime_dependency(%q<builder>.freeze, ["~> 3.0", ">= 3.0.4"])
    else
      s.add_dependency(%q<bundler>.freeze, ["~> 1.13"])
      s.add_dependency(%q<nokogiri>.freeze, ["~> 1.6", ">= 1.6.8"])
      s.add_dependency(%q<mocha>.freeze, ["~> 0.13.3"])
      s.add_dependency(%q<pry-byebug>.freeze, ["~> 3.4", ">= 3.4.2"])
      s.add_dependency(%q<rake>.freeze, ["~> 10.0"])
      s.add_dependency(%q<rspec>.freeze, ["~> 3.0"])
      s.add_dependency(%q<travis>.freeze, ["~> 1.8", ">= 1.8.8"])
      s.add_dependency(%q<builder>.freeze, ["~> 3.0", ">= 3.0.4"])
    end
  else
    s.add_dependency(%q<bundler>.freeze, ["~> 1.13"])
    s.add_dependency(%q<nokogiri>.freeze, ["~> 1.6", ">= 1.6.8"])
    s.add_dependency(%q<mocha>.freeze, ["~> 0.13.3"])
    s.add_dependency(%q<pry-byebug>.freeze, ["~> 3.4", ">= 3.4.2"])
    s.add_dependency(%q<rake>.freeze, ["~> 10.0"])
    s.add_dependency(%q<rspec>.freeze, ["~> 3.0"])
    s.add_dependency(%q<travis>.freeze, ["~> 1.8", ">= 1.8.8"])
    s.add_dependency(%q<builder>.freeze, ["~> 3.0", ">= 3.0.4"])
  end
end

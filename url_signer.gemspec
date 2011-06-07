# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "url_signer/version"

Gem::Specification.new do |s|
  s.name        = "url_signer"
  s.version     = UrlSigner::VERSION
  s.authors     = ["Rémy Coutable"]
  s.email       = ["rymai@rymai.me"]
  s.homepage    = ""
  s.summary     = %q{An easy way to get signed URLs using HMAC functionality}
  s.description = %q{Given an URL and a private key, UrlSigner returns you a signed URL ready to use for API calls}

  s.rubyforge_project = "url_signer"

  s.files        = Dir.glob('lib/**/*') + %w[CHANGELOG.md LICENSE README.md]
  s.require_path = 'lib'

  s.add_dependency 'ruby-hmac', '>= 0.4.0'

  s.add_development_dependency 'rake',    '~> 0.9'
  s.add_development_dependency 'bundler', '~> 1.0'
  s.add_development_dependency 'rspec',   '~> 2.6'
end

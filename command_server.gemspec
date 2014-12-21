# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'command_server/version'

Gem::Specification.new do |spec|
  spec.name          = "command_server"
  spec.version       = CommandServer::VERSION
  spec.authors       = ["clicube"]
  spec.email         = ["clicube@gmail.com"]
  spec.summary       = %q{Library to put command into running ruby process via socket.}
  spec.description   = %q{Library to put command into running ruby process via socket. You can check status of the process and execute methods.}
  spec.homepage      = "https://github.com/clicube/command_server"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
end

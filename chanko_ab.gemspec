
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "chanko_ab/version"

Gem::Specification.new do |spec|
  spec.name          = "chanko_ab"
  spec.version       = ChankoAb::VERSION
  spec.authors       = ["morita shingo"]
  spec.email         = ["morita.shingo@gmail.com"]
  spec.summary       = %q{ab test extension for chanko}
  spec.description   = %q{ab test extension for chanko}

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})

  spec.add_development_dependency "chanko", ">= 2.1.0"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "byebug"
end

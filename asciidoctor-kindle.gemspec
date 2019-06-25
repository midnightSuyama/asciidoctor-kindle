lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'asciidoctor-kindle/version'

Gem::Specification.new do |spec|
  spec.name          = "asciidoctor-kindle"
  spec.version       = Asciidoctor::Kindle::VERSION
  spec.authors       = ["midnightSuyama"]
  spec.email         = ["midnightSuyama@gmail.com"]

  spec.summary       = "Asciidoctor extension for converting html to mobi"
  spec.description   = "Asciidoctor extension for converting html to mobi"
  spec.homepage      = "https://github.com/midnightSuyama/asciidoctor-kindle"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "bin"
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest", "~> 5.0"
  spec.add_development_dependency "minitest-hooks", "~> 1.5"

  spec.add_runtime_dependency "asciidoctor"
  spec.add_runtime_dependency "kindlegen"
end

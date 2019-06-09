
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "dsp/version"


Gem::Specification.new do |spec|
  spec.name          = "dsp"
  spec.version       = Dsp::VERSION
  spec.authors       = ["micahshute"]
  spec.email         = ["micah.shute@gmail.com"]

  spec.summary       = %q{Perform basic Digital Signal Processing tasks, including convolution, fft, filtering.}
  spec.description   = %q{Allows design of digital signals using the FFT, design of Digital Filters using the Windowing Method, creation of Digital Signals or Analog Signals sampled at a certain interval, convolution, cross-correlation, and visualization of the data. .}
  spec.homepage      = "https://rubygems.org/gems/dsp"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    # spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"

    spec.metadata["homepage_uri"] = spec.homepage
    spec.metadata["source_code_uri"] = "https://github.com/micahshute/dsp"
    spec.metadata["changelog_uri"] = "https://github.com/micahshute/dsp"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency 'rdoc'
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'gruff', "~> 0.7.0" 
  spec.add_runtime_dependency "gruff", "~> 0.7.0"
  # spec.add_dependency "gruff"
end


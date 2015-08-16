lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "ruboty/calendar_alert/version"

Gem::Specification.new do |spec|
  spec.name          = "ruboty-calendar_alert"
  spec.version       = Ruboty::CalendarAlert::VERSION
  spec.authors       = ["mallowlabs"]
  spec.email         = ["mallowlabs@gmail.com"]
  spec.summary       = "Calendar alerting on Ruboty"
  spec.homepage      = "https://github.com/mallowlabs/ruboty-calendar_alert"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "ruboty-cron"
  spec.add_dependency "icalendar"
  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
end

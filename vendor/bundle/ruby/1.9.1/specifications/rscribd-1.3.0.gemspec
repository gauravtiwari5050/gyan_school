# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "rscribd"
  s.version = "1.3.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Tim Morgan", "Jared Friedman", "Mike Watts"]
  s.date = "2011-07-06"
  s.description = "The official Ruby gem for the Scribd API. Scribd is a document-sharing website allowing people to upload and view documents online."
  s.email = "api@scribd.com"
  s.extra_rdoc_files = ["README"]
  s.files = ["README"]
  s.homepage = "http://www.scribd.com/developers"
  s.require_paths = ["lib"]
  s.rubyforge_project = "rscribd"
  s.rubygems_version = "1.8.11"
  s.summary = "Ruby client library for the Scribd API"

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<mime-types>, [">= 0"])
      s.add_development_dependency(%q<rspec>, [">= 0"])
      s.add_development_dependency(%q<yard>, [">= 0"])
    else
      s.add_dependency(%q<mime-types>, [">= 0"])
      s.add_dependency(%q<rspec>, [">= 0"])
      s.add_dependency(%q<yard>, [">= 0"])
    end
  else
    s.add_dependency(%q<mime-types>, [">= 0"])
    s.add_dependency(%q<rspec>, [">= 0"])
    s.add_dependency(%q<yard>, [">= 0"])
  end
end

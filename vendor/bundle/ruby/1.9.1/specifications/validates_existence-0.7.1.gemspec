# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "validates_existence"
  s.version = "0.7.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Tanel Suurhans", "Tarmo Lehtpuu"]
  s.date = "2011-10-26"
  s.description = "A library for validating model association existence."
  s.email = ["tanel.suurhans@perfectline.ee", "tarmo.lehtpuu@perfectline.ee"]
  s.extra_rdoc_files = ["README.markdown"]
  s.files = ["README.markdown"]
  s.homepage = "http://github.com/perfectline/validates_existence/tree/master"
  s.require_paths = ["lib"]
  s.rubygems_version = "1.8.11"
  s.summary = "Validates Rails model belongs_to association existence."

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end

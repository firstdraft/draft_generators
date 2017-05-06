# Generated by juwelier
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Juwelier::Tasks in Rakefile, and run 'rake gemspec'
# -*- encoding: utf-8 -*-
# stub: firstdraft_generators 0.0.1 ruby lib

Gem::Specification.new do |s|
  s.name = "firstdraft_generators".freeze
  s.version = "0.0.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Raghu Betina".freeze]
  s.date = "2017-05-06"
  s.description = "This is a set of generators that help beginners learn to program. Primarily, they generate code that is more explicit and verbose and less idiomatic and \u{201c}magical\u{201d} than the built-in scaffold generator, which is helpful for beginners while they are learning how exactly things are wired together.".freeze
  s.email = "raghu@firstdraft.com".freeze
  s.extra_rdoc_files = [
    "LICENSE.txt",
    "README.markdown"
  ]
  s.files = [
    ".document",
    ".rspec",
    "Gemfile",
    "Gemfile.lock",
    "LICENSE.txt",
    "README.markdown",
    "Rakefile",
    "VERSION",
    "lib/firstdraft_generators.rb",
    "lib/generators/draft/resource/USAGE",
    "lib/generators/draft/resource/migration.rb",
    "lib/generators/draft/resource/resource_generator.rb",
    "lib/generators/draft/resource/templates/bootstrapped/edit_form.html.erb",
    "lib/generators/draft/resource/templates/bootstrapped/index.html.erb",
    "lib/generators/draft/resource/templates/bootstrapped/new_form.html.erb",
    "lib/generators/draft/resource/templates/bootstrapped/show.html.erb",
    "lib/generators/draft/resource/templates/controller.rb",
    "lib/generators/draft/resource/templates/crud_spec.rb",
    "lib/generators/draft/resource/templates/dried/_form.html.erb",
    "lib/generators/draft/resource/templates/dried/bootstrapped/_form.html.erb",
    "lib/generators/draft/resource/templates/dried/bootstrapped/edit.html.erb",
    "lib/generators/draft/resource/templates/dried/bootstrapped/index.html.erb",
    "lib/generators/draft/resource/templates/dried/bootstrapped/new.html.erb",
    "lib/generators/draft/resource/templates/dried/bootstrapped/show.html.erb",
    "lib/generators/draft/resource/templates/dried/controller.rb",
    "lib/generators/draft/resource/templates/dried/edit.html.erb",
    "lib/generators/draft/resource/templates/dried/index.html.erb",
    "lib/generators/draft/resource/templates/dried/new.html.erb",
    "lib/generators/draft/resource/templates/dried/show.html.erb",
    "lib/generators/draft/resource/templates/edit.html.erb",
    "lib/generators/draft/resource/templates/factories.rb",
    "lib/generators/draft/resource/templates/index.html.erb",
    "lib/generators/draft/resource/templates/migration.rb",
    "lib/generators/draft/resource/templates/model.rb",
    "lib/generators/draft/resource/templates/new.html.erb",
    "lib/generators/draft/resource/templates/read_only/controller.rb",
    "lib/generators/draft/resource/templates/show.html.erb",
    "lib/generators/draft/style/USAGE",
    "lib/generators/draft/style/style_generator.rb",
    "lib/generators/draft/style/templates/application.css",
    "lib/generators/draft/style/templates/bootstrap-4-spacers.scss",
    "lib/generators/draft/style/templates/layout.html.erb"
  ]
  s.homepage = "http://github.com/raghubetina/firstdraft_generators".freeze
  s.licenses = ["MIT".freeze]
  s.rubygems_version = "2.6.11".freeze
  s.summary = "Generators that help beginners learn to program.".freeze

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<rspec>.freeze, ["~> 3.5.0"])
      s.add_development_dependency(%q<rdoc>.freeze, ["~> 3.12"])
      s.add_development_dependency(%q<bundler>.freeze, ["~> 1.0"])
      s.add_development_dependency(%q<juwelier>.freeze, ["~> 2.1.0"])
      s.add_development_dependency(%q<simplecov>.freeze, [">= 0"])
    else
      s.add_dependency(%q<rspec>.freeze, ["~> 3.5.0"])
      s.add_dependency(%q<rdoc>.freeze, ["~> 3.12"])
      s.add_dependency(%q<bundler>.freeze, ["~> 1.0"])
      s.add_dependency(%q<juwelier>.freeze, ["~> 2.1.0"])
      s.add_dependency(%q<simplecov>.freeze, [">= 0"])
    end
  else
    s.add_dependency(%q<rspec>.freeze, ["~> 3.5.0"])
    s.add_dependency(%q<rdoc>.freeze, ["~> 3.12"])
    s.add_dependency(%q<bundler>.freeze, ["~> 1.0"])
    s.add_dependency(%q<juwelier>.freeze, ["~> 2.1.0"])
    s.add_dependency(%q<simplecov>.freeze, [">= 0"])
  end
end

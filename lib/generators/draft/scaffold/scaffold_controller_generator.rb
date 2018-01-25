# frozen_string_literal: true

require "generators/draft/scaffold/scaffold_erb_generator"
require "rails/generators/rails/scaffold_controller/scaffold_controller_generator"

module Draft
  class ScaffoldControllerGenerator < ::Rails::Generators::ScaffoldControllerGenerator
    source_root Rails::Generators::ScaffoldControllerGenerator.source_root

    remove_hook_for :template_engine

    def generate_views
      invoke Draft::ScaffoldErbGenerator
    end
  end
end

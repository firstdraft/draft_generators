# frozen_string_literal: true

require "generators/draft/scaffold/scaffold_controller_generator"
require "rails/generators/rails/scaffold/scaffold_generator"

module Draft
  class ScaffoldGenerator < ::Rails::Generators::ScaffoldGenerator
    remove_hook_for :scaffold_controller
    remove_hook_for :assets

    def generate_controller
      invoke Draft::ScaffoldControllerGenerator
    end
  end
end

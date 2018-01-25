require 'generators/draft/scaffold/scaffold_controller_generator'
require 'rails/generators/rails/scaffold/scaffold_generator'

module Draft
  class ScaffoldGenerator < ::Rails::Generators::ScaffoldGenerator
    remove_hook_for :scaffold_controller

    def generate_controller
      invoke Draft::ScaffoldControllerGenerator
      puts "#{'-'*100}"
    end

  end
end

# frozen_string_literal: true

require "generators/devise/devise_generator"
require "generators/active_record/devise_generator"

module Draft
  class DeviseGenerator < Devise::Generators::DeviseGenerator
    source_root Devise::Generators::DeviseGenerator.source_root

    remove_hook_for :orm
    remove_hook_for :add_devise_routes

    class_option :routes, desc: "Generate routes", type: :boolean, default: true

    def add_devise_routes
      if !model_exists?
        devise_route = "devise_for :#{plural_name}".dup
        devise_route << %Q(, class_name: "#{class_name}") if class_name.include?("::")
        devise_route << %Q(, skip: :all) unless options.routes?
        route devise_route
      else
        say "\nThis model(#{class_name}) is already registered with devise\n"
      end
    end

    def enable_scoped_views
      unless model_exists?
        uncomment_lines("config/initializers/devise.rb",
          /.*config.scoped_views = false/)
        end
    end

    def orm
      invoke ActiveRecord::Generators::DeviseGenerator unless model_exists?
    end

    private

    def model_exists?
      File.exist?(File.join(destination_root, model_path))
    end

    def model_path
      @model_path ||= File.join("app", "models", "#{file_path}.rb")
    end
  end
end

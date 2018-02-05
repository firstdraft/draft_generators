# frozen_string_literal: true

require 'rails/generators/named_base'

module Draft
  class DeviseGenerator < Rails::Generators::NamedBase
    argument :attributes, type: :array, default: [], banner: "field:type field:type"
    include Rails::Generators::ResourceHelpers

    def check_for_existing_devise_model
      if model_exists?
        say "\nYou already have a model called #{class_name}! Halting generator.\n"
        abort
      end
    end

    def devise_install
      unless initializer_exists?
        invoke 'devise:install'
      end
      uncomment_lines("config/initializers/devise.rb",
          /.*config.scoped_views = false/)
    end

    def generate_devise_model
      invoke 'devise'
    end

    def generate_devise_views
      invoke 'draft:devise:views'
      devise_service = ::DraftGenerators::DeviseCustomizationService.new(attributes)
      add_additional_views_through_security(devise_service)
      add_additional_fields_for_registration(devise_service)
    end

    private

    def add_additional_views_through_security(devise_service)
      inject_into_file("app/controllers/application_controller.rb",
                       devise_service.security_field_block,
                       after: devise_service.protect_from_forgery_code)
    end

    def add_additional_fields_for_registration(devise_service)
      scope = name.underscore.pluralize

      inject_into_file("app/views/#{scope}/registrations/new.html.erb",
                       devise_service.form_fields_to_add,
                       before: devise_service.sign_in_resource_button_block)
      
      inject_into_file("app/views/#{scope}/registrations/edit.html.erb",
                       devise_service.form_fields_to_add,
                       before: devise_service.update_resource_button_block)
    end

    def model_exists?
      File.exist?(File.join(destination_root, model_path))
    end

    def model_path
      @model_path ||= File.join("app", "models", "#{file_path}.rb")
    end

    def initializer_exists?
      File.exist?(File.join(destination_root, initializer_path))
    end

    def initializer_path
      @initializer_path ||= File.join("config", "initializers", "devise.rb")
    end
  end
end

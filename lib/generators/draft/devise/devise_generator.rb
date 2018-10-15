# frozen_string_literal: true

require "rails/generators/named_base"

module Draft
  class DeviseGenerator < Rails::Generators::NamedBase
    argument :attributes, type: :array, default: [],
                          banner: "field:type field:type"
    class_option :with_sentinels, type: :boolean, default: false, desc: "Skip adding comments to generated files"
    class_option :views, aliases: "-v", type: :array, desc: "Select specific view directories to generate (confirmations, passwords, registrations, sessions, unlocks, mailer)"

    include Rails::Generators::ResourceHelpers

    def check_for_existing_devise_model
      return if behavior != :invoke
      if model_exists?
        say "\nYou already have a model called #{class_name}! Halting generator.\n"
        abort
      end
    end

    def devise_install
      unless initializer_exists?
        invoke "devise:install"
      end
    end

    def enable_scoped_views
      path = "config/initializers/devise.rb"
      uncomment_lines(path, /.*config.scoped_views = false/)
      code_to_replace = "config.scoped_views = false"
      replace_with = "config.scoped_views = true"
      gsub_file(path, code_to_replace, replace_with)
    end

    def generate_devise_model
      invoke "devise"
    end

    def generate_devise_views
      invoke "draft:devise:views"
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
      form_fields_to_add = devise_service.form_fields_to_add
      
      if File.exist?("app/views/#{scope}/registrations/new.html.erb")
        inject_into_file("app/views/#{scope}/registrations/new.html.erb",
                         form_fields_to_add,
                         before: devise_service.sign_in_resource_button_block)
      end

      if File.exist?("app/views/#{scope}/registrations/edit.html.erb")
        inject_into_file("app/views/#{scope}/registrations/edit.html.erb",
                         form_fields_to_add,
                         before: devise_service.update_resource_button_block)
      end
    end
    
    def with_sentinels?
      options[:with_sentinels]
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

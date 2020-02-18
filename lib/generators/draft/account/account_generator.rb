require "rails/generators/named_base"

module Draft
  class AccountGenerator < Rails::Generators::NamedBase
    source_root File.expand_path("../templates", __FILE__)

    argument :attributes, type: :array, default: [],
                                        banner: "field:type field:type"

    include Rails::Generators::ResourceHelpers

    def generate_required_attributes
      unless attributes_has_password_digest?
        password_digest = Rails::Generators::GeneratedAttribute.parse(["password_digest", :string, nil].compact.join(":"))
        attributes.unshift(password_digest)
      end
      unless attributes_has_email?
        email = Rails::Generators::GeneratedAttribute.parse(["email", :string, nil].compact.join(":"))
        attributes.unshift(email)
      end
    end

    def generate_model
      invoke "draft:model", paramaterize_attributes
      edit_model
    end

    def generate_routes
      authentication_routes
    end

    def generate_before_actions
      authentication_helpers
    end

    def generate_controller
      template "controllers/sessions_controller.rb", "app/controllers/#{singular_table_name.underscore}_sessions_controller.rb"
      template "controllers/controller.rb", "app/controllers/#{plural_table_name.underscore}_controller.rb"
    end

    def create_root_folder
      empty_directory File.join("app/views", "#{singular_table_name.underscore}_sessions")
      empty_directory File.join("app/views", "#{plural_table_name.underscore}")
    end
    
    def generate_view_files
      available_views.select{|filename| filename.include?("sign")}.each do |view|
        filename = view_sessions_filename_with_extensions(view)
        template filename, File.join("app/views/#{singular_table_name.underscore}_sessions", File.basename(filename))
      end

      available_views.reject{|filename| filename.include?("sign")}.each do |view|
        filename = view_filename_with_extensions(view)
        template filename, File.join("app/views/#{plural_table_name.underscore}", File.basename(filename))
      end
    end
    
    private

    def authentication_routes
      log :route, "Authentication routes"

      route <<-RUBY.gsub(/^      /, "")

        # Routes for the #{singular_table_name.humanize} account:

        # SIGN UP FORM
        get("/#{singular_table_name.underscore}_sign_up", { :controller => "#{plural_table_name.underscore}", :action => "new_registration_form" })        
        # CREATE RECORD
        post("/insert_#{singular_table_name.underscore}", { :controller => "#{plural_table_name.underscore}", :action => "create"  })
            
        # EDIT PROFILE FORM        
        get("/edit_#{singular_table_name.underscore}_profile", { :controller => "#{plural_table_name.underscore}", :action => "edit_registration_form" })       
        # UPDATE RECORD
        post("/modify_#{singular_table_name.underscore}", { :controller => "#{plural_table_name.underscore}", :action => "update" })
        
        # DELETE RECORD
        get("/cancel_#{singular_table_name.underscore}_account", { :controller => "#{plural_table_name.underscore}", :action => "destroy" })

        # ------------------------------

        # SIGN IN FORM
        get("/#{singular_table_name.underscore}_sign_in", { :controller => "#{singular_table_name.underscore}_sessions", :action => "new_session_form" })
        # AUTHENTICATE AND STORE COOKIE
        post("/#{singular_table_name.underscore}_verify_credentials", { :controller => "#{singular_table_name.underscore}_sessions", :action => "create_cookie" })
        
        # SIGN OUT        
        get("/#{singular_table_name.underscore}_sign_out", { :controller => "#{singular_table_name.underscore}_sessions", :action => "destroy_cookies" })
                   
        #------------------------------
      RUBY
    end

    def authentication_helpers
      log :controller, "Authentication before_actions"

      application_controller <<-RUBY.gsub(/^      /, "")

        before_action(:load_current_#{singular_table_name.underscore})
        
        # before_action(:force_#{singular_table_name.underscore}_sign_in)
        
        def load_current_#{singular_table_name.underscore}
          the_id = session.fetch(:#{singular_table_name.underscore}_id)
          @current_#{singular_table_name.underscore} = #{class_name.singularize}.where({ :id => the_id }).at(0)
        end
        
        def force_#{singular_table_name.underscore}_sign_in
          if @current_#{singular_table_name.underscore} == nil
            redirect_to("/#{singular_table_name.underscore}_sign_in", { :notice => "You have to sign in first." })
          end
        end
      RUBY
    end

    def edit_model
      sentinel = /.*ApplicationRecord\n/
      content = "  validates :email, :uniqueness => { :case_sensitive => false }\n"\
        "  validates :email, :presence => true\n"\
        "  has_secure_password\n"
      if model_exists?
        inside "app/models" do
          insert_into_file "#{singular_table_name.underscore}.rb", content, after: sentinel
        end
      end
    end

    def route(routing_code)
      sentinel = /\.routes\.draw do(?:\s*\|map\|)?\s*$/

      inside "config" do
        insert_into_file "routes.rb", routing_code, after: sentinel
      end
    end

    def application_controller(app_code)
      sentinel = /::Base$/

      inside "app/controllers" do
        insert_into_file "application_controller.rb", app_code, after: sentinel
      end
    end

    def available_views
      %w(sign_up sign_in edit_profile edit_profile_with_errors)
    end

    def view_filename_with_extensions(name)
      filename = [name, :html, :erb].compact.join(".")
      folders = ["views"]
      filename = File.join(folders, filename) if folders.any?
      filename
    end

    def view_sessions_filename_with_extensions(name)
      filename = [name, :html, :erb].compact.join(".")
      folders = ["views", "sessions"]
      filename = File.join(folders, filename) if folders.any?
      filename
    end

    def controller_filename_with_extensions(name)
      filename = [name,:rb].compact.join(".")
      folders = ["controllers"]
      filename = File.join(folders, filename) if folders.any?
      filename
    end

    def model_exists?
      File.exist?(File.join(destination_root, model_path))
    end

    def model_path
      @model_path ||= File.join("app", "models", "#{file_path}.rb")
    end

    def attributes_has_email?
      attributes.any? { |attribute| attribute.column_name.include?("email") }
    end

    def attributes_has_password_digest?
      attributes.any?{ |attribute| attribute.column_name.include?("password_digest") }
    end

    def paramaterize_attributes
      array = [singular_table_name.underscore]
      attributes.each do |attribute|
        array.push(attribute.column_name + ":" + attribute.type.to_s)
      end
      array
    end

  end
end

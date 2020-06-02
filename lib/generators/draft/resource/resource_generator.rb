require 'indefinite_article'

module Draft
  class ResourceGenerator < Rails::Generators::NamedBase
    source_root File.expand_path("../templates", __FILE__)

    argument :attributes, type: :array, default: [], banner: "field:type field:type"
    class_option :skip_model, type: :boolean, default: false, desc: "Skip model, migration, and specs"
    class_option :skip_controller, type: :boolean, default: false, desc: "Skip controller and routes"
    class_option :read_only, type: :boolean, default: false, desc: "Only generates the index and show actions"
    class_option :skip_validation_alerts, type: :boolean, default: false, desc: "Skip validation failure alerts"
    class_option :skip_post, type: :boolean, default: false, desc: "Skip HTTP POST verb"
    class_option :skip_redirect, type: :boolean, default: false, desc: "Skip redirecting after create, update, and destroy"
    class_option :only_new_form, type: :boolean, default: false, desc: "Generate association new form"
    class_option :new_form_name, type: :string, default: "", desc: "Partial name"
    class_option :associated_table_name, type: :string, default: "", desc: "Associatiated table name"
    class_option :with_sentinels, type: :boolean, default: false, desc: "Skip adding comments to generated files"

    def generate_controller
      return if skip_controller?

      if read_only?
        template "controllers/read_only_controller.rb", "app/controllers/#{plural_table_name.underscore}_controller.rb"
      else
        template "controllers/controller.rb", "app/controllers/#{plural_table_name.underscore}_controller.rb"
      end
    end

    def generate_model
      return if skip_model?
      invoke "draft:model"
    end

    def create_root_folder
      empty_directory File.join("app/views", "#{plural_table_name}")
    end

    def generate_view_files
      available_views.each do |view|
        filename = view_filename_with_extensions(view)
        template filename, File.join("app/views", "#{plural_table_name}", File.basename(options[:new_form_name].presence || filename))
      end
    end

    def generate_routes
      return if skip_controller?

      if read_only?
        read_only_routes
      else
        golden_five_routes
      end
    end

    def generate_specs
      # Hotfix to prevent specs during MSM Associations
      return
      # return if read_only? || skip_controller? || skip_model?

      template "specs/crud_spec.rb", "spec/features/crud_#{plural_table_name.underscore}_spec.rb"
      template "specs/factories.rb", "spec/factories/#{plural_table_name.underscore}.rb"
    end

  private

    def golden_five_routes
      log :route, "RESTful routes"

      route <<-RUBY.gsub(/^      /, "")

        # Routes for the #{singular_table_name.humanize} resource:

        # CREATE
        post("/insert_#{singular_table_name}", { :controller => "#{plural_table_name}", :action => "create" })
                
        # READ
        get("/#{plural_table_name}", { :controller => "#{plural_table_name}", :action => "index" })
        
        get("/#{plural_table_name}/:path_id", { :controller => "#{plural_table_name}", :action => "show" })
        
        # UPDATE
        
        post("/modify_#{singular_table_name}/:path_id", { :controller => "#{plural_table_name}", :action => "update" })
        
        # DELETE
        get("/delete_#{singular_table_name}/:path_id", { :controller => "#{plural_table_name}", :action => "destroy" })

        #------------------------------
      RUBY
    end

    def read_only_routes
      log :route, "Index and show routes"

      route <<-RUBY.gsub(/^      /, "")
      
        # Routes for the #{singular_table_name.humanize} resource:

        # READ
        get("/#{plural_table_name}", { :controller => "#{plural_table_name}", :action => "index", :via => "get"})
        get("/#{plural_table_name}/:path_id", { :controller => "#{plural_table_name}", :action => "show", :via => "get"})
        
        #------------------------------
      RUBY
    end

    def skip_controller?
      options[:skip_controller] || options[:only_new_form]
    end

    def skip_model?
      options[:skip_model] || options[:only_new_form]
    end

    def read_only?
      options[:read_only]
    end

    def skip_validation_alerts?
      options[:skip_validation_alerts]
    end

    def skip_post?
      options[:skip_post]
    end

    def skip_redirect?
      options[:skip_redirect]
    end

    def only_new_form?
      options[:only_new_form]
    end

    def with_sentinels?
      options[:with_sentinels]
    end

    def new_form_hidden_variable
      "@#{options[:associated_table_name].singularize}.id"
    end

    def new_form_create_path
      "create_#{singular_table_name}_from_#{options[:associated_table_name].singularize}"
    end

    def route(routing_code)
      sentinel = /\.routes\.draw do(?:\s*\|map\|)?\s*$/

      inside "config" do
        insert_into_file "routes.rb", routing_code, after: sentinel
      end
    end

    def available_views
      if read_only?
        %w(index show)
      elsif skip_redirect?
        %w(index show new_form create_row edit_form update_row destroy_row)
      elsif only_new_form?
        %w(association_new_form)
      else
        %w(index show)
      end
    end

    def view_filename_with_extensions(name)
      filename = [name, :html, :erb].compact.join(".")
      folders = ["views"]
      filename = File.join(folders, filename) if folders.any?
      filename
    end
  end
end

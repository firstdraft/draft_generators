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

      invoke "draft:model", ARGV

      if Gem.loaded_specs.has_key? "activeadmin"
        invoke "active_admin:resource", [singular_table_name]

        permit_active_admin_params
      end
    end

    def generate_view_files
      available_views.each do |view|
        filename = view_filename_with_extensions(view)
        template filename, File.join("app/views", "#{plural_table_name}_templates", File.basename(filename))
      end
    end

    def generate_routes
      return if skip_controller?

      if read_only?
        read_only_routes
      else
        golden_seven_routes
      end
    end

    def generate_specs
      return if read_only? || skip_controller? || skip_model?

      template "specs/crud_spec.rb", "spec/features/crud_#{plural_table_name.underscore}_spec.rb"
      template "specs/factories.rb", "spec/factories/#{plural_table_name.underscore}.rb"
    end

  private

    def golden_seven_routes
      log :route, "RESTful routes"

      route <<-RUBY.gsub(/^      /, "")

        # Routes for the #{singular_table_name.humanize} resource:

        # CREATE
        get("/#{plural_table_name}/new", { :controller => "#{plural_table_name}", :action => "new_form" })
        #{skip_post? ? "get" : "post"}("/create_#{singular_table_name}", { :controller => "#{plural_table_name}", :action => "create_row" })

        # READ
        get("/#{plural_table_name}", { :controller => "#{plural_table_name}", :action => "index" })
        get("/#{plural_table_name}/:id_to_display", { :controller => "#{plural_table_name}", :action => "show" })

        # UPDATE
        get("/#{plural_table_name}/:prefill_with_id/edit", { :controller => "#{plural_table_name}", :action => "edit_form" })
        #{skip_post? ? "get" : "post"}("/update_#{singular_table_name}/:id_to_modify", { :controller => "#{plural_table_name}", :action => "update_row" })

        # DELETE
        get("/delete_#{singular_table_name}/:id_to_remove", { :controller => "#{plural_table_name}", :action => "destroy_row" })

        #------------------------------
      RUBY
    end

    def read_only_routes
      log :route, "Index and show routes"

      route <<-RUBY.gsub(/^      /, "")
        # Routes for the #{singular_table_name.humanize} resource:

        # READ
        get("/#{plural_table_name}", { :controller => "#{plural_table_name}", :action => "index" })
        get("/#{plural_table_name}/:id_to_display", { :controller => "#{plural_table_name}", :action => "show" })

        #------------------------------
      RUBY
    end

    def skip_controller?
      options[:skip_controller]
    end

    def skip_model?
      options[:skip_model]
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

    def route(routing_code)
      sentinel = /\.routes\.draw do(?:\s*\|map\|)?\s*$/

      inside "config" do
        insert_into_file "routes.rb", routing_code, after: sentinel
      end
    end

    def permit_active_admin_params
      sentinel = /.*ActiveAdmin.register.*do.*/

      inside "app" do
        inside "admin" do
          if File.exist?("#{singular_table_name}.rb")
            insert_into_file "#{singular_table_name}.rb", after: sentinel do
              "\n  permit_params #{attributes_names.map { |name| ":#{name}" }.join(", ")}\n"
            end
          end
        end
      end
    end

    def available_views
      if read_only?
        %w(index show)
      elsif skip_redirect?
        %w(index show new_form create_row edit_form update_row destroy_row)
      else
        %w(index new_form edit_form show)
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

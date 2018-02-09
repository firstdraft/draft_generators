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
    class_option :buggy, type: :boolean, default: false, desc: "Creates buggy resources for RCAV and Golden Seven practice"

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
    end

    def generate_view_files
      available_views.each do |view|
        filename = view_filename_with_extensions(view)
        template filename, File.join("app/views", "#{singular_table_name}_templates", File.basename(filename))
      end
    end

    def generate_routes
      return if skip_controller?

      if read_only?
        buggy? ? buggy_read_only_routes : read_only_routes
      else
        buggy? ? buggy_golden_seven_routes : golden_seven_routes
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

    def buggy_golden_seven_routes
      log :route, "Buggy Golden Seven routes"
      max_route_bugs = rand(2) + 4
      bug_count = 0

      if create_bug?(likelihood: :high) && bug_count < max_route_bugs
        new_form_route = buggy_new_form_route
        bug_count += 1
      else
        new_form_route = <<-RUBY.gsub(/^      /, "")
      get("/#{plural_table_name}/new", { :controller => "#{plural_table_name}", :action => "new_form" })
        RUBY
      end

      if create_bug?(likelihood: :high) && bug_count < max_route_bugs
        create_row_route = buggy_create_row_route
        bug_count += 1
      else
        create_row_route = <<-RUBY.gsub(/^      /, "")
      #{skip_post? ? "get" : "post"}("/create_#{singular_table_name}", { :controller => "#{plural_table_name}", :action => "create_row" })
        RUBY
      end

      if create_bug?(likelihood: :high) && bug_count < max_route_bugs
        index_route = buggy_index_route
        bug_count += 1
      else
        index_route = <<-RUBY.gsub(/^      /, "")
      get("/#{plural_table_name}", { :controller => "#{plural_table_name}", :action => "index" })
        RUBY
      end

      if create_bug?(likelihood: :high) && bug_count < max_route_bugs
        show_route = buggy_show_route
        bug_count += 1
      else
        show_route = <<-RUBY.gsub(/^      /, "")
      get("/#{plural_table_name}/:id_to_display", { :controller => "#{plural_table_name}", :action => "show" })
        RUBY
      end

      if create_bug?(likelihood: :high) && bug_count < max_route_bugs
        edit_form_route = buggy_edit_form_route
        bug_count += 1
      else
        edit_form_route = <<-RUBY.gsub(/^      /, "")
      get("/#{plural_table_name}/:prefill_with_id/edit", { :controller => "#{plural_table_name}", :action => "edit_form" })
        RUBY
      end

      if create_bug?(likelihood: :high) && bug_count < max_route_bugs
        update_route = buggy_update_route
        bug_count += 1
      else
        update_route = <<-RUBY.gsub(/^      /, "")
      #{skip_post? ? "get" : "post"}("/update_#{singular_table_name}/:id_to_modify", { :controller => "#{plural_table_name}", :action => "update_row" })
        RUBY
      end

      if create_bug?(likelihood: :high) && bug_count < max_route_bugs
        destroy_row_route = buggy_destroy_row_route
        bug_count += 1
      else
        destroy_row_route = <<-RUBY.gsub(/^      /, "")
      get("/delete_#{singular_table_name}/:id_to_remove", { :controller => "#{plural_table_name}", :action => "destroy_row" })
        RUBY
      end

      route <<-RUBY.gsub(/^      /, "")

        # Routes for the #{singular_table_name.humanize} resource:

        # CREATE
        #{new_form_route}  #{create_row_route}
        # READ
        #{index_route}  #{show_route}
        # UPDATE
        #{edit_form_route}  #{update_route}
        # DELETE
        #{destroy_row_route}
      RUBY
      puts "#{bug_count} route bugs created"
    end

    def buggy_read_only_routes
      log :route, "Buggy index and show routes"

      max_route_bugs = 2
      bug_count = 0

      if create_bug?(likelihood: :high) && bug_count < max_route_bugs
        index_route = buggy_index_route
        bug_count += 1
      else
        index_route = <<-RUBY.gsub(/^      /, "")
      get("/#{plural_table_name}", { :controller => "#{plural_table_name}", :action => "index" })
        RUBY
      end

      if create_bug?(likelihood: :high) && bug_count < max_route_bugs
        show_route = buggy_show_route
        bug_count += 1
      else
        show_route = <<-RUBY.gsub(/^      /, "")
      get("/#{plural_table_name}/:id_to_display", { :controller => "#{plural_table_name}", :action => "show" })
        RUBY
      end

      route <<-RUBY.gsub(/^      /, "")
        # Routes for the #{singular_table_name.humanize} resource:

        # READ
        #{index_route}  #{show_route}

        #------------------------------
      RUBY
    end

    def buggy_new_form_route
      bug_option = rand(2) + 1
      if bug_option == 1
        <<-RUBY.gsub(/^      /, "")
      get("/new_#{plural_table_name}", { :controller => "#{plural_table_name}", :action => "new_form" })
        RUBY
      elsif bug_option == 2
        <<-RUBY.gsub(/^      /, "")
      get("/new_#{plural_table_name}", { :controller => "#{plural_table_name}", :action => "new" })
        RUBY
      end
    end

    def buggy_create_row_route
        <<-RUBY.gsub(/^      /, "")
      #{skip_post? ? "get" : "post"}("/create_#{singular_table_name}", { controller => "#{plural_table_name}", action => "create_row" })
        RUBY
    end

    def buggy_index_route
      bug_option = rand(2) + 1
      if bug_option == 1
        <<-RUBY.gsub(/^      /, "")
      get("/#{plural_table_name}", { :controller => "#{plural_table_name}", :action => "#{plural_table_name}" })
        RUBY
      elsif bug_option == 2
        <<-RUBY.gsub(/^      /, "")
      get("/#{plural_table_name}", { :controller => #{plural_table_name}, :action => index })
        RUBY
      end
    end

    def buggy_show_route
      bug_option = rand(2) + 1
      if bug_option == 1
        <<-RUBY.gsub(/^      /, "")
      get("/#{plural_table_name}/id_to_display", { :controller => "#{plural_table_name}", :action => "show" })
        RUBY
      elsif bug_option == 2
        <<-RUBY.gsub(/^      /, "")
      get("/#{plural_table_name}/:id_to_display", { controller => "#{plural_table_name}", :action => "show" })
        RUBY
      end
    end

    def buggy_edit_form_route
      bug_option = rand(2) + 1
      if bug_option == 1
        <<-RUBY.gsub(/^      /, "")
      get("/#{plural_table_name}/prefill_with_id/edit", { :controller => "#{plural_table_name}", :action => "edit_form" })
        RUBY
      elsif bug_option == 2
        <<-RUBY.gsub(/^      /, "")
      get("/#{plural_table_name}/:prefill_with_id/edit", { :controller => #{plural_table_name}, :action => "edit" })
        RUBY
      end
    end

    def buggy_update_route
      bug_option = rand(2) + 1
      if bug_option == 1
        <<-RUBY.gsub(/^      /, "")
      #{skip_post? ? "get" : "post"}("/update_#{singular_table_name}/id_to_modify", { :controller => "#{plural_table_name}", :action => "update_row" })
        RUBY
      elsif bug_option == 2
        <<-RUBY.gsub(/^      /, "")
      #{skip_post? ? "get" : "post"}("/update_#{singular_table_name}/id_to_modify", { controller => "#{plural_table_name}", action => "update_row" })
        RUBY
      end
    end

    def buggy_destroy_row_route
      bug_option = rand(2) + 1
      if bug_option == 1
        <<-RUBY.gsub(/^      /, "")
      get("/delete_#{singular_table_name}/id_to_remove", { :controller => "#{plural_table_name}", :action => "destroy_row" })
        RUBY
      elsif bug_option == 2
        <<-RUBY.gsub(/^      /, "")
      get("/delete_#{singular_table_name}/:id_to_remove", { controller => "#{plural_table_name}", action => "destroy" })
        RUBY
      end
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
      options[:skip_validation_alerts] || options[:skip_redirect]
    end

    def skip_post?
      options[:skip_post]
    end

    def skip_redirect?
      options[:skip_redirect]
    end

    def buggy?
      options[:buggy]
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

    def create_bug?(likelihood_hash)
      if likelihood_hash.fetch(:likelihood) == :high
        return rand(10) > 3
      elsif likelihood_hash.fetch(:likelihood) == :low
        return rand(10) > 7
      elsif likelihood_hash.fetch(:likelihood) == :none
        return false
      elsif likelihood_hash.fetch(:likelihood) == :total
        return true
      else
        return rand(10) > 5
      end
    end
  end
end

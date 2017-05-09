module Draft
  class LayoutGenerator < Rails::Generators::Base
    source_root File.expand_path('../templates', __FILE__)

    class_option :theme, type: :string, default: "none", desc: "Bootstrap theme"
    class_option :layout_file, type: :string, default: "application", desc: "Layout filename"
    class_option :skip_cdn, type: :boolean, default: false, desc: "Skip connecting CDN assets"

    def generate_layout
      if bootswatch?
        log :insert, "Adding #{theme_name.capitalize} Bootswatch"
      else
        log :insert, "Adding Bootstrap"
      end

      log :insert, "Adding Font Awesome"
      log :insert, "Adding navbar"
      log :insert, "Adding alerts"
      log :insert, "Adding sticky footer; you may need to add

                padding-bottom: 70px

              to the body of the document."

      template "layout.html.erb", "app/views/layouts/#{options["layout_file"]}.html.erb"

      template "_navbar.html.erb", "app/views/shared/_navbar.html.erb"

      template "_flashes.html.erb", "app/views/shared/_flashes.html.erb"

      template "_footer.html.erb", "app/views/shared/_footer.html.erb"

      unless skip_cdn?
        template "_bootstrapcdn_assets.html.erb", "app/views/shared/_bootstrapcdn_assets.html.erb"
      end
    end

  protected

    def bootswatch?
      if theme_name.present?
        theme_name != "none"
      end
    end

    def theme_name
      options["theme"].downcase
    end

    def skip_cdn?
      options["skip_cdn"]
    end

    def app_resources
      models = ApplicationRecord.descendants.reject do |klass|
        if klass.name == "AdminUser"
          true
        else
          false
        end
      end
      models.collect { |clazz| clazz.name.underscore.pluralize }
    end

    def devise_routes
      route_names.map do |name|
        /new_(.*)_registration/.match(name)
      end.compact
    end

    def route_names
      @route_names ||= Rails.application.routes.routes.map(&:name).uniq.compact
    end
  end
end

module Draft
  class ApiGenerator < Rails::Generators::NamedBase
    source_root File.expand_path("../templates", __FILE__)

    class_option :'api-namespace',
      type: :string,
      default: "/api/v1",
      desc: "Override namespace for API controller & routes"

    def install_graphiti_boilerplate
      if behavior == :invoke && !graphiti_config_exists? && !vandal_installed?
        generate "draft:graphiti_boilerplate", "--api-namespace=#{@options["api-namespace"]}"
      elsif behavior == :revoke
        puts "========================================"
        puts "To uninstall Graphiti and Vandal boilerplate code, run 'rails destroy draft:graphiti_boilerplate'"
        puts "========================================"
      end
    end


    def generate_graphiti_resource
      puts "Generating Graphiti Resource"
      unless ActiveRecord::Base.connection.table_exists?(plural_table_name)
        puts "Migrating..."
        rake("db:migrate")
      end

      if behavior == :invoke
        generate "graphiti:resource", "#{singular_table_name} -m=#{singular_table_name}"
      elsif behavior == :revoke
        invoke "graphiti:resource"
      end

    end

    private

    def graphiti_config
      File.exist?(".graphiticfg.yml") ? YAML.load_file(".graphiticfg.yml") : {}
    end

    def api_namespace
      @api_namespace ||= graphiti_config["namespace"]
    end

    def graphiti_config_exists?
      File.exist?(".graphiticfg.yml")
    end

    def controller_path
      "app/controllers/#{plural_table_name}_controller.rb"
    end

    def controller_exists?
      File.exists?(controller_path)
    end

    def vandal_installed?
      File.exists?("public#{api_namespace}/vandal/index.htmls")
    end

  end
end

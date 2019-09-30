module Draft
  class GraphitiBoilerplateGenerator < Rails::Generators::Base
    source_root File.expand_path("../templates", __FILE__)
    class_option :'api-namespace',
      type: :string,
      default: "/api/v1",
      desc: "Override namespace for API controller & routes"

    def install_boilerplate
      install_graphiti
      install_vandal
    end

    private

    def graphiti_config
      File.exist?(".graphiticfg.yml") ? YAML.load_file(".graphiticfg.yml") : {}
    end

    def api_namespace
      @api_namespace ||= (graphiti_config["namespace"] || @options["api-namespace"])
    end

    def install_graphiti
      if behavior == :invoke
        generate "graphiti:install", "--api-namespace=#{api_namespace} --namespace-controllers"
      elsif behavior == :revoke
        puts "Uninstalling Graphiti"
        invoke "graphiti:install"
      end
    end

    def install_vandal
      if behavior == :invoke
        if File.exists?("public#{api_namespace}/vandal/index.html")
          puts "Vandal already installed"
        else
          puts "Installing Vandal"
          rake("vandal:install")
        end
      elsif behavior == :revoke
        puts "Uninstalling Vandal"
        vandal_path  = File.expand_path("public#{api_namespace}/vandal")
        files = Dir["#{vandal_path}/**/*"]
        files << File.expand_path("public#{api_namespace}/vandal")

        files.each do |path|
          say_status :remove, relative_to_original_destination_root(path), true
          ::FileUtils.rm_rf(path) if !options[:pretend] && File.exist?(path)
        end
      end
    end

  end
end

module Draft
  class ApiGenerator < Rails::Generators::NamedBase

    def install_graphiti
      unless graphiti_config_exists?
        create_file ".graphiticfg.yml",
<<-FILE
---
namespace: "/api"
        FILE
        puts "Installing Graphiti"
        invoke "graphiti:install"
      end

    end

    def install_vandal
      unless File.exists?("public/api/vandal/index.html")
        puts "Installing Vandal"
        rake("vandal:install")
      end
    end
    #
    # def generate_graphiti_resource
    #   puts "Generating Graphiti Resource"
    #   unless ActiveRecord::Base.connection.table_exists?(plural_table_name)
    #     puts "Migrating..."
    #     rake("db:migrate")
    #   end
    #   controller_backup = File.open(controller_path).read
    #   invoke "graphiti:resource", [singular_table_name, "-m=#{singular_table_name}"], skip:true
    #   unless controller_exists?
    #     File.open(controller_path, "w") {|f| f.write(controller_backup) }
    #   end
    # end

    def insert_controller_code
      insert_controller_index
    end

    private

    def graphiti_config_exists?
      File.exist?(".graphiticfg.yml")
    end

    def controller_path
      "app/controllers/#{plural_table_name}_controller.rb"
    end

    def controller_exists?
      File.exists?(controller_path)
    end

    def insert_controller_index
      matcher = /render\({ :template => "apples\/index.html.erb" }\)\s+end\n/
      code = "\nformat.jsonapi do\n  #{plural_table_name} = #{class_name}Resource.all(params)\n  respond_with(#{plural_table_name})\nend\n"
      inject_into_file controller_path, after: matcher, force: true do
        indent(code, 6)
      end
    end

    def insert_controller_show

    end

    def insert_controller_create

    end

    def insert_controller_update

    end

    def insert_controller_destroy

    end

  end
end

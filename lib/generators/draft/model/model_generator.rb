module Draft
  class ModelGenerator < Rails::Generators::ModelGenerator

    def generate_active_admin
      if Gem.loaded_specs.has_key? "activeadmin"
        invoke "active_admin:resource", [singular_table_name]

        permit_active_admin_params
      end
    end

  private

    def permit_active_admin_params
      sentinel = /.*ActiveAdmin.register.*do.*/

      if File.exist?("app/admin/#{singular_table_name}.rb")
        inside "app" do
          inside "admin" do
            insert_into_file "#{singular_table_name}.rb", after: sentinel do
              "\n  permit_params #{attributes_names.map { |name| ":#{name}" }.join(", ")}\n"
            end
          end
        end
      end
    end
  end
end

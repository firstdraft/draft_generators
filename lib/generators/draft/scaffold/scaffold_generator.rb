# frozen_string_literal: true
require "rails/generators/named_base"
require "rails/generators/resource_helpers"

module Draft
  class ScaffoldGenerator < Rails::Generators::NamedBase
    source_root File.expand_path("../templates", __FILE__)

    argument :attributes, type: :array, default: [], 
      banner: "field:type field:type"

    def create_root_folder
      empty_directory File.join("app/views", controller_file_path)
    end

    def copy_view_files
      available_views.each do |view|
        template view, File.join("app/views", controller_file_path, view)
      end
    end

    protected

    def available_views
      base = self.class.source_root
      base_len = base.length
      Dir[File.join(base, "**", "*")].
        select { |f| File.file?(f) }.
        map { |f| f[base_len..-1] }
    end
  end
end

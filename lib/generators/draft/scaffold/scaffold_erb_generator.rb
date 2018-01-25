# frozen_string_literal: true

require "rails/generators/erb/scaffold/scaffold_generator"

module Draft
  class ScaffoldErbGenerator < Erb::Generators::ScaffoldGenerator
    source_root File.expand_path("../templates", __FILE__)

    def copy_view_files
      available_views.each do |view|
        template view, File.join("app/views", controller_file_path, view)
      end
    end

    protected

    def available_views
      base = self.class.source_root
      base_len = base.length + 1
      Dir[File.join(base, "**", "*")].
        select { |f| File.file?(f) }.
        map { |f| f[base_len..-1] }
    end
  end
end

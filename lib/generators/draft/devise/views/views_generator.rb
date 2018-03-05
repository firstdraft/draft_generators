# frozen_string_literal: true

require "generators/devise/views_generator"

module Draft
  module Devise
    class FormForGenerator < ::Devise::Generators::FormForGenerator
      source_root File.expand_path("../templates", __FILE__)
    end

    class ViewsGenerator < ::Devise::Generators::ViewsGenerator
      desc "Copies Draft Devise views to your application."

      remove_hook_for :form_builder

      def form_builder
        invoke Draft::Devise::FormForGenerator
      end
    end
  end
end

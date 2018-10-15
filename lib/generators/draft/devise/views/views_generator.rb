# frozen_string_literal: true

require "generators/devise/views_generator"

module Draft
  module Devise
    class FormForGenerator < ::Devise::Generators::FormForGenerator
      source_root File.expand_path("../templates", __FILE__)
      class_option :with_sentinels, type: :boolean, default: false, desc: "Skip adding comments to generated files"

      def generate_registrations
        if with_sentinels?
          view_directory :registrations_with_sentinels, "app/views/#{plural_scope}/registrations"
          view_directory :mailer, "app/views/#{plural_scope}/mailer"
        else
          view_directory :registrations
        end
      end

      def with_sentinels?
        options[:with_sentinels]
      end
    end

    class ViewsGenerator < ::Devise::Generators::ViewsGenerator
      desc "Copies Draft Devise views to your application."
      class_option :with_sentinels, type: :boolean, default: false, desc: "Skip adding comments to generated files"
      class_option :views, aliases: "-v", type: :array, desc: "Select specific view directories to generate (confirmations, passwords, registrations, sessions, unlocks, mailer)"

      remove_hook_for :form_builder

      def form_builder
        invoke Draft::Devise::FormForGenerator
      end

      def with_sentinels?
        options[:with_sentinels]
      end
    end
  end
end

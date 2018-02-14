# frozen_string_literal: true

module DraftGenerators
  class DeviseCustomizationService
    def initialize(attributes)
      @attributes = attributes
    end

    def form_fields_to_add
      form_fields = ""
      columns.each do |column|
        form_fields += input_field_block(column)
      end
      form_fields
    end

    def input_field_block(column)
      %{          
          <!-- Devise Input for #{column.name} start -->
          <div class="form-group">
            <% #{column.name}_was_invalid = resource.errors.include?(:#{column.name}) %>

            <% #{column.name}_class = "form-control" %>

            <% if was_validated %>
              <% if #{column.name}_was_invalid %>
                <% #{column.name}_class << " is-invalid" %>
              <% else %>
                <% #{column.name}_class << " is-valid" %>
              <% end %>
            <% end %>

            <%= f.label :#{column.name} %>

            #{DraftGenerators::RailsTagService.input_tag(column)}

            <% if #{column.name}_was_invalid %>
              <% resource.errors.full_messages_for(:#{column.name}).each do |message| %>
                <div class="invalid-feedback">
                  <%= message %>
                </div>
              <% end %>
            <% end %>
          </div>
          <!-- Devise Input for #{column.name} end -->
}
    end

    def security_field_block
      return "" if eligible_attributes.empty?
        "

  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, :keys => [#{column_names_string}])

    devise_parameter_sanitizer.permit(:account_update, :keys => [#{column_names_string}])
  end"
    end

    def update_resource_button_block
      %{          <%= f.submit "Update", class: "btn btn-block btn-outline-primary" %>}
    end

    def sign_in_resource_button_block
      %{          <%= f.button class: "btn btn-outline-primary btn-block" %>}
    end

    def column_names
      columns.map(&:name)
    end

    def column_names_string
      ":" + column_names.join(", :").to_s
    end

    def protect_from_forgery_code
      "protect_from_forgery with: :exception"
    end

    def columns
      @_columns ||=  eligible_attributes
    end

    def eligible_attributes
      @attributes.reject do |attribute|
        %w(id created_at updated_at email password).include?(attribute.name)
      end
    end
  end
end

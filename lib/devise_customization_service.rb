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
      "<div class=\"form-group\">
          <\%= f.label :#{column.name}, class: \"col-sm-2 control-label\" \%>
          <div class=\"col-sm-10\">
            #{DraftGenerators::RailsTagService.input_tag(column)}
          </div>
        </div>

        "
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
      %Q{<div class="form-group">
            <div class="col-sm-10 col-sm-offset-2">
              <%= f.submit "Update", class: "btn btn-success btn-block" %>
            </div>
          </div>}
    end

    def sign_in_resource_button_block
      %Q{<div class="form-group">
          <div class="col-sm-10 col-sm-offset-2">
            <%= f.submit "Sign up", class: "btn btn-success btn-block" %>
          </div>
        </div>}
    end

    def column_names
      columns.map { |column| column.name }
    end

    def column_names_string
      ":" + "#{column_names.join(", :")}"
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

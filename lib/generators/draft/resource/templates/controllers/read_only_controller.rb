class <%= plural_table_name.camelize %>Controller < ApplicationController
  def index
    @<%= plural_table_name.underscore %> = <%= class_name.singularize %>.all

    render("<%= singular_table_name.underscore %>_templates/index.html.erb")
  end

  def show
    @<%= singular_table_name.underscore %> = <%= class_name.singularize %>.find(params.fetch("id"))

    render("<%= singular_table_name.underscore %>_templates/show.html.erb")
  end
end

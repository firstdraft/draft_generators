class <%= plural_table_name.camelize %>Controller < ApplicationController
  def index
    @<%= plural_table_name.underscore %> = <%= class_name.singularize %>.all

    render("<%= singular_table_name.underscore %>_templates/index")
  end

  def show
    @<%= singular_table_name.underscore %> = <%= class_name.singularize %>.find(params.fetch("id_to_display"))

    render("<%= singular_table_name.underscore %>_templates/show")
  end
end

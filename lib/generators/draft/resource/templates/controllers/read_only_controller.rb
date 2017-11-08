class <%= plural_table_name.camelize %>Controller < ApplicationController
  def index
    @list_of_<%= plural_table_name %> = <%= class_name.singularize %>.all.order({ :created_at => :desc })

    render("<%= singular_table_name %>_templates/index.html.erb")
  end

  def show
    id_of_<%= singular_table_name %>_to_show = params.fetch("id_to_display")

    @<%= singular_table_name %>_to_show = <%= class_name.singularize %>.find(id_of_<%= singular_table_name %>_to_show)

    render("<%= singular_table_name %>_templates/show.html.erb")
  end
end

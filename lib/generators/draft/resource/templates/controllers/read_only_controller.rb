class <%= plural_table_name.camelize %>Controller < ApplicationController
  def index
    all_<%= plural_table_name %> = <%= class_name.singularize %>.all.order(:created_at => :desc)

    render("<%= plural_table_name %>_templates/index.html.erb", :locals => {
      :list_of_<%= plural_table_name %> => all_<%= plural_table_name %>
    })
  end

  def show
    <%= singular_table_name %>_to_show = <%= class_name.singularize %>.find(params[:id_to_display])

    render("<%= plural_table_name %>_templates/show.html.erb", :locals => {
      :the_<%= singular_table_name %> => <%= singular_table_name %>_to_show
    })
  end
end

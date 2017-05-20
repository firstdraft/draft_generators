class <%= plural_table_name.camelize %>Controller < ApplicationController
  def index
    all_<%= plural_table_name %> = <%= class_name.singularize %>.all.order(:created_at => :desc)

    render("<%= singular_table_name %>_templates/index.html.erb", :locals => {
      :list_of_<%= plural_table_name %> => all_<%= plural_table_name %>
    })
  end

  def show
    <%= singular_table_name %>_to_show = <%= class_name.singularize %>.find(params["id_to_display"])

    render("<%= singular_table_name %>_templates/show.html.erb", :locals => {
      :the_<%= singular_table_name %> => <%= singular_table_name %>_to_show
    })
  end

  def new_form
<% unless skip_validation_alerts? -%>
    dummy_<%= singular_table_name %> = <%= class_name.singularize %>.new

<% end -%>
    render("<%= singular_table_name %>_templates/new_form.html.erb", :locals => {
      :<%= singular_table_name %>_with_errors => dummy_<%= singular_table_name %>
    })
  end

  def create_row
    <%= singular_table_name %>_to_add = <%= class_name.singularize %>.new

<% attributes.each do |attribute| -%>
    <%= singular_table_name %>_to_add.<%= attribute.column_name %> = params["<%= attribute.column_name %>_from_form"]
<% end -%>

<% unless skip_validation_alerts? -%>
    save_status = <%= singular_table_name %>_to_add.save

    if save_status == true
      redirect_to("/<%= plural_table_name %>", :notice => "<%= singular_table_name.humanize %> created successfully.")
    else
      render("<%= singular_table_name %>_templates/new_form.html.erb", :locals => {
        :<%= singular_table_name %>_with_errors => <%= singular_table_name %>_to_add
      })
    end
<% else -%>
    <%= singular_table_name %>_to_add.save

<% unless skip_redirect? -%>
    redirect_to("/<%= plural_table_name %>")
<% else -%>
    render("<%= singular_table_name %>_templates/create_row.html.erb", :locals => {
      :current_count => <%= class_name.singularize %>.count
    })
<% end -%>
<% end -%>
  end

  def edit_form
    existing_<%= singular_table_name %> = <%= class_name.singularize %>.find(params["prefill_with_id"])

    render("<%= singular_table_name %>_templates/edit_form.html.erb", :locals => {
      :<%= singular_table_name %>_to_prefill => existing_<%= singular_table_name %>
    })
  end

  def update_row
    <%= singular_table_name %>_to_change = <%= class_name.singularize %>.find(params["id_to_modify"])

<% attributes.each do |attribute| -%>
    <%= singular_table_name %>_to_change.<%= attribute.column_name %> = params["<%= attribute.column_name %>_from_form"]
<% end -%>

<% unless skip_validation_alerts? -%>
    save_status = <%= singular_table_name %>_to_change.save

    if save_status == true
      redirect_to("/<%= plural_table_name %>/#{<%= singular_table_name %>_to_change.id}", :notice => "<%= singular_table_name.humanize %> updated successfully.")
    else
      render("<%= singular_table_name %>_templates/edit_form.html.erb", :locals => {
        :<%= singular_table_name %>_to_prefill => <%= singular_table_name %>_to_change
      })
    end
<% else -%>
    <%= singular_table_name %>_to_change.save

<% unless skip_redirect? -%>
    redirect_to("/<%= plural_table_name %>/#{<%= singular_table_name %>_to_change.id}")
<% else -%>
    render("<%= singular_table_name %>_templates/update_row.html.erb", :locals => {
      :<%= singular_table_name %>_to_prefill => <%= singular_table_name %>_to_change
    })
<% end -%>
<% end -%>
  end

  def destroy_row
    <%= singular_table_name %>_to_delete = <%= class_name.singularize %>.find(params["id_to_remove"])

    <%= singular_table_name %>_to_delete.destroy

<% unless skip_validation_alerts? -%>
    redirect_to("/<%= plural_table_name %>", :notice => "<%= singular_table_name.humanize %> deleted successfully.")
<% else -%>
<% unless skip_redirect? -%>
    redirect_to("/<%= plural_table_name %>")
<% else -%>
    render("<%= singular_table_name %>_templates/destroy_row.html.erb", :locals => {
      :remaining_count => <%= class_name.singularize %>.count
    })
<% end -%>
<% end -%>
  end
end

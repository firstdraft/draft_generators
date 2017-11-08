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

  def new_form
    render("<%= singular_table_name %>_templates/new_form.html.erb")
  end

  def create_row
    @<%= singular_table_name %> = <%= class_name.singularize %>.new

<% attributes.each do |attribute| -%>
    @<%= singular_table_name %>.<%= attribute.column_name %> = params.fetch("<%= attribute.column_name %>_from_form")
<% end -%>

<% unless skip_validation_alerts? -%>
    save_status = @<%= singular_table_name %>.save

    if save_status == true
      redirect_to("/<%= plural_table_name %>", :notice => "<%= singular_table_name.humanize %> created successfully.")
    else
      render("<%= singular_table_name %>_templates/new_form_with_errors.html.erb")
    end
<% else -%>
    @<%= singular_table_name %>.save

<% unless skip_redirect? -%>
    redirect_to("/<%= plural_table_name %>")
<% else -%>
    @current_<%= singular_table_name %>_count = <%= class_name.singularize %>.count

    render("<%= singular_table_name %>_templates/create_row.html.erb")
<% end -%>
<% end -%>
  end

  def edit_form
    id_of_<%= singular_table_name %>_to_prefill = params.fetch("id_to_edit")

    @<%= singular_table_name %> = <%= class_name.singularize %>.find(id_of_<%= singular_table_name %>_to_prefill)

    render("<%= singular_table_name %>_templates/edit_form.html.erb")
  end

  def update_row
    id_of_<%= singular_table_name %>_to_change = params.fetch("id_to_modify")

    @<%= singular_table_name %>_to_change = <%= class_name.singularize %>.find(id_of_<%= singular_table_name %>_to_change)

<% attributes.each do |attribute| -%>
    @<%= singular_table_name %>_to_change.<%= attribute.column_name %> = params.fetch("<%= attribute.column_name %>_from_form")
<% end -%>

<% unless skip_validation_alerts? -%>
    save_status = @<%= singular_table_name %>_to_change.save

    if save_status == true
      redirect_to("/<%= plural_table_name %>/#{@<%= singular_table_name %>_to_change.id}", :notice => "<%= singular_table_name.humanize %> updated successfully.")
    else
      render("<%= singular_table_name %>_templates/edit_form_with_errors.html.erb")
    end
<% else -%>
    @<%= singular_table_name %>_to_change.save

<% unless skip_redirect? -%>
    redirect_to("/<%= plural_table_name %>/#{@<%= singular_table_name %>_to_change.id}")
<% else -%>
    render("<%= singular_table_name %>_templates/update_row.html.erb")
<% end -%>
<% end -%>
  end

  def destroy_row
    id_of_<%= singular_table_name %>_to_delete = params.fetch("id_to_remove")

    @<%= singular_table_name %>_to_toast = <%= class_name.singularize %>.find(id_of_<%= singular_table_name %>_to_delete)

    @<%= singular_table_name %>_to_toast.destroy

<% unless skip_validation_alerts? -%>
    redirect_to("/<%= plural_table_name %>", :notice => "<%= singular_table_name.humanize %> deleted successfully.")
<% else -%>
<% unless skip_redirect? -%>
    redirect_to("/<%= plural_table_name %>")
<% else -%>
    @remaining_<%= singular_table_name %>_count = <%= class_name.singularize %>.count

    render("<%= singular_table_name %>_templates/destroy_row.html.erb")
<% end -%>
<% end -%>
  end
end

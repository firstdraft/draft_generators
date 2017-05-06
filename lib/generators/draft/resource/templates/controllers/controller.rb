class <%= plural_table_name.camelize %>Controller < ApplicationController
  def index
    @<%= plural_table_name.underscore %> = <%= class_name %>.all

    render("<%= plural_table_name.underscore %>_templates/index.html.erb")
  end

  def show
    @<%= singular_table_name.underscore %> = <%= class_name %>.find(params[:id_to_display])

    render("<%= plural_table_name.underscore %>_templates/show.html.erb")
  end

  def new_form
<% unless skip_validation_alerts? -%>
    @<%= singular_table_name.underscore %> = <%= class_name %>.new
<% end -%>
    render("<%= plural_table_name.underscore %>_templates/new_form.html.erb")
  end

  def create_row
    @<%= singular_table_name.underscore %> = <%= class_name %>.new

<% attributes.each do |attribute| -%>
    @<%= singular_table_name.underscore %>.<%= attribute.column_name %> = params[:<%= attribute.column_name %>]
<% end -%>

<% unless skip_validation_alerts? -%>
    save_status = @<%= singular_table_name.underscore %>.save

    if save_status == true
      redirect_to("/<%= @plural_table_name.underscore %>", :notice => "<%= singular_table_name.humanize %> created successfully.")
    else
      render("<%= plural_table_name.underscore %>_templates/new_form.html.erb")
    end
<% else -%>
    @<%= singular_table_name.underscore %>.save

<% unless skip_redirect? -%>
    redirect_to("/<%= @plural_table_name.underscore %>")
<% else -%>
    @current_count = <%= class_name %>.count

    render("<%= plural_table_name.underscore %>_templates/create_row.html.erb")
<% end -%>
<% end -%>
  end

  def edit_form
    @<%= singular_table_name.underscore %> = <%= class_name %>.find(params[:prefill_with_id])

    render("<%= plural_table_name.underscore %>_templates/edit_form.html.erb")
  end

  def update_row
    @<%= singular_table_name.underscore %> = <%= class_name %>.find(params[:id_to_modify])

<% attributes.each do |attribute| -%>
    @<%= singular_table_name.underscore %>.<%= attribute.column_name %> = params[:<%= attribute.column_name %>]
<% end -%>

<% unless skip_validation_alerts? -%>
    save_status = @<%= singular_table_name.underscore %>.save

    if save_status == true
      redirect_to("/<%= @plural_table_name.underscore %>/#{@<%= singular_table_name.underscore %>.id}", :notice => "<%= singular_table_name.humanize %> updated successfully.")
    else
      render("<%= plural_table_name.underscore %>_templates/edit_form.html.erb")
    end
<% else -%>
    @<%= singular_table_name.underscore %>.save

<% unless skip_redirect? -%>
    redirect_to("/<%= @plural_table_name.underscore %>/#{@<%= singular_table_name.underscore %>.id}")
<% else -%>
    render("<%= plural_table_name.underscore %>_templates/update_row.html.erb")
<% end -%>
<% end -%>
  end

  def destroy_row
    @<%= singular_table_name.underscore %> = <%= class_name %>.find(params[:id_to_remove])

    @<%= singular_table_name.underscore %>.destroy

<% unless skip_validation_alerts? -%>
    redirect_to("/<%= @plural_table_name.underscore %>", :notice => "<%= singular_table_name.humanize %> deleted successfully.")
<% else -%>
<% unless skip_redirect? -%>
    redirect_to("/<%= @plural_table_name.underscore %>")
<% else -%>
    @remaining_count = <%= class_name %>.count

    render("<%= plural_table_name.underscore %>_templates/destroy_row.html.erb")
<% end -%>
<% end -%>
  end
end

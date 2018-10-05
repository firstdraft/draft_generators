class <%= plural_table_name.camelize %>Controller < ApplicationController
  def index
    @<%= plural_table_name.underscore %> = <%= class_name.singularize %>.all

    render("<%= singular_table_name.underscore %>_templates/index.html.erb")
  end

  def show
    @<%= singular_table_name.underscore %> = <%= class_name.singularize %>.find(params.fetch("id_to_display"))

    render("<%= singular_table_name.underscore %>_templates/show.html.erb")
  end

  def new_form
    @<%= singular_table_name.underscore %> = <%= class_name.singularize %>.new

    render("<%= singular_table_name.underscore %>_templates/new_form.html.erb")
  end

  def create_row
    @<%= singular_table_name.underscore %> = <%= class_name.singularize %>.new

<% attributes.each do |attribute| -%>
    @<%= singular_table_name.underscore %>.<%= attribute.column_name %> = params.fetch("<%= attribute.column_name %>")
<% end -%>

<% unless skip_validation_alerts? -%>
    if @<%= singular_table_name.underscore %>.valid?
      @<%= singular_table_name.underscore %>.save

      redirect_back(:fallback_location => "/<%= @plural_table_name.underscore %>", :notice => "<%= singular_table_name.humanize %> created successfully.")
    else
      render("<%= singular_table_name.underscore %>_templates/new_form_with_errors.html.erb")
    end
<% else -%>
    @<%= singular_table_name.underscore %>.save

<% unless skip_redirect? -%>
    redirect_to("/<%= @plural_table_name.underscore %>")
<% else -%>
    @current_count = <%= class_name.singularize %>.count

    render("<%= singular_table_name.underscore %>_templates/create_row.html.erb")
<% end -%>
<% end -%>
  end

  def edit_form
    @<%= singular_table_name.underscore %> = <%= class_name.singularize %>.find(params.fetch("prefill_with_id"))

    render("<%= singular_table_name.underscore %>_templates/edit_form.html.erb")
  end

  def update_row
    @<%= singular_table_name.underscore %> = <%= class_name.singularize %>.find(params.fetch("id_to_modify"))

<% attributes.each do |attribute| -%>
    @<%= singular_table_name.underscore %>.<%= attribute.column_name %> = params.fetch("<%= attribute.column_name %>")
<% end -%>

<% unless skip_validation_alerts? -%>
    if @<%= singular_table_name.underscore %>.valid?
      @<%= singular_table_name.underscore %>.save

      redirect_to("/<%= @plural_table_name.underscore %>/#{@<%= singular_table_name.underscore %>.id}", :notice => "<%= singular_table_name.humanize %> updated successfully.")
    else
      render("<%= singular_table_name.underscore %>_templates/edit_form_with_errors.html.erb")
    end
<% else -%>
    @<%= singular_table_name.underscore %>.save

<% unless skip_redirect? -%>
    redirect_to("/<%= @plural_table_name.underscore %>/#{@<%= singular_table_name.underscore %>.id}")
<% else -%>
    render("<%= singular_table_name.underscore %>_templates/update_row.html.erb")
<% end -%>
<% end -%>
  end

  def destroy_row
    @<%= singular_table_name.underscore %> = <%= class_name.singularize %>.find(params.fetch("id_to_remove"))

    @<%= singular_table_name.underscore %>.destroy

<% unless skip_validation_alerts? -%>
    redirect_to("/<%= @plural_table_name.underscore %>", :notice => "<%= singular_table_name.humanize %> deleted successfully.")
<% else -%>
<% unless skip_redirect? -%>
    redirect_to("/<%= @plural_table_name.underscore %>")
<% else -%>
    @remaining_count = <%= class_name.singularize %>.count

    render("<%= singular_table_name.underscore %>_templates/destroy_row.html.erb")
<% end -%>
<% end -%>
  end
end

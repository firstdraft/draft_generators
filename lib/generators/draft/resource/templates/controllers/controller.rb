class <%= plural_table_name.camelize %>Controller < ApplicationController
  def index
    @list_of_<%= plural_table_name.underscore %> = <%= class_name.singularize %>.all.order({ :created_at => :desc })

    render({ :template => "<%= plural_table_name.underscore %>/index.html.erb" })
  end

  def show
    the_id = params.fetch("path_id")
    @the_<%= singular_table_name.underscore %> = <%= class_name.singularize %>.where({ :id => the_id }).at(0)

    render({ :template => "<%= plural_table_name.underscore %>/show.html.erb" })
  end

  def create
    @the_<%= singular_table_name.underscore %> = <%= class_name.singularize %>.new
<% attributes.each do |attribute| -%>
<% if attribute.field_type == :check_box -%>
    @the_<%= singular_table_name.underscore %>.<%= attribute.column_name %> = params.fetch("query_<%= attribute.column_name %>", false)
<% else -%>
    @the_<%= singular_table_name.underscore %>.<%= attribute.column_name %> = params.fetch("query_<%= attribute.column_name %>")
<% end -%>
<% end -%>

<% unless skip_validation_alerts? -%>
    if @the_<%= singular_table_name.underscore %>.valid?
      @the_<%= singular_table_name.underscore %>.save
      redirect_to("/<%= plural_table_name.underscore %>", { :notice => "<%= singular_table_name.humanize %> created successfully." })
    else
      redirect_to("/<%= plural_table_name.underscore %>", { :notice => "<%= singular_table_name.humanize %> failed to create successfully." })
    end
<% else -%>
    @the_<%= singular_table_name.underscore %>.save

<% unless skip_redirect? -%>
    redirect_to("/<%= @plural_table_name.underscore %>")
<% else -%>
    @current_count = <%= class_name.singularize %>.count

    render("<%= singular_table_name.underscore %>_templates/create_row.html.erb")
<% end -%>
<% end -%>
  end

  def update
    the_id = params.fetch("path_id")
    @the_<%= singular_table_name.underscore %> = <%= class_name.singularize %>.where({ :id => the_id }).at(0)

<% attributes.each do |attribute| -%>
<% if attribute.field_type == :check_box -%>
    @the_<%= singular_table_name.underscore %>.<%= attribute.column_name %> = params.fetch("query_<%= attribute.column_name %>", false)
<% else -%>
    @the_<%= singular_table_name.underscore %>.<%= attribute.column_name %> = params.fetch("query_<%= attribute.column_name %>")
<% end -%>
<% end -%>

<% unless skip_validation_alerts? -%>
    if @the_<%= singular_table_name.underscore %>.valid?
      @the_<%= singular_table_name.underscore %>.save
      redirect_to("/<%= @plural_table_name.underscore %>/#{@the_<%= singular_table_name.underscore %>.id}", { :notice => "<%= singular_table_name.humanize %> updated successfully."} )
    else
      redirect_to("/<%= @plural_table_name.underscore %>/#{@the_<%= singular_table_name.underscore %>.id}", { :alert => "<%= singular_table_name.humanize %> failed to update successfully." })
    end
<% else -%>
    @the_<%= singular_table_name.underscore %>.save

<% unless skip_redirect? -%>
    redirect_to("/<%= @plural_table_name.underscore %>/#{@the_<%= singular_table_name.underscore %>.id}")
<% else -%>
      render({ :template => "<%= plural_table_name.underscore %>/show.html.erb" })
  <% end -%>
<% end -%>
  end

  def destroy
    the_id = params.fetch("path_id")
    @the_<%= singular_table_name.underscore %> = <%= class_name.singularize %>.where({ :id => the_id }).at(0)

    @the_<%= singular_table_name.underscore %>.destroy

<% unless skip_validation_alerts? -%>
    redirect_to("/<%= @plural_table_name.underscore %>", { :notice => "<%= singular_table_name.humanize %> deleted successfully."} )
<% else -%>
<% unless skip_redirect? -%>
    redirect_to("/<%= @plural_table_name.underscore %>")
<% else -%>
    @remaining_count = <%= class_name.singularize %>.count
    
    redirect_to("/<%= @plural_table_name.underscore %>", { :notice => "<%= singular_table_name.humanize %> deleted successfully."} )    
<% end -%>
<% end -%>
  end
end

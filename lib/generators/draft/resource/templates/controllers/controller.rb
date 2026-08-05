class <%= plural_table_name.camelize %>Controller < ApplicationController
  def index
    matching_<%= plural_table_name.underscore %> = <%= class_name.singularize %>.all

    @list_of_<%= plural_table_name.underscore %> = matching_<%= plural_table_name.underscore %>.order({ :created_at => :desc })

    render({ :template => "<%= singular_table_name.underscore %>_templates/index" })
  end

  def show
    the_id = params.fetch("path_id")

    matching_<%= plural_table_name.underscore.downcase %> = <%= class_name.singularize %>.where({ :id => the_id })

    @the_<%= singular_table_name.underscore %> = matching_<%= plural_table_name.underscore.downcase %>.at(0)

    render({ :template => "<%= singular_table_name.underscore %>_templates/show" })
  end

  def create
    the_<%= singular_table_name.underscore %> = <%= class_name.singularize %>.new
<% attributes.each do |attribute| -%>
<% if [:check_box, :checkbox].include?(attribute.field_type) -%>
    the_<%= singular_table_name.underscore %>.<%= attribute.column_name %> = params.fetch("<%= attribute.column_name %>_param", false)
<% else -%>
    the_<%= singular_table_name.underscore %>.<%= attribute.column_name %> = params.fetch("<%= attribute.column_name %>_param")
<% end -%>
<% end -%>

<% unless skip_validation_alerts? -%>
    if the_<%= singular_table_name.underscore %>.valid?
      the_<%= singular_table_name.underscore %>.save
      redirect_to("/<%= plural_table_name.underscore %>", { :notice => "<%= singular_table_name.humanize %> created successfully." })
    else
      redirect_to("/<%= plural_table_name.underscore %>", { :alert => the_<%= singular_table_name.underscore %>.errors.full_messages.to_sentence })
    end
<% else -%>
    the_<%= singular_table_name.underscore %>.save

<% unless skip_redirect? -%>
    redirect_to("/<%= @plural_table_name.underscore %>")
<% else -%>
    @current_count = <%= class_name.singularize %>.count

    render("<%= singular_table_name.underscore %>_templates/create_row")
<% end -%>
<% end -%>
  end

  def update
    the_id = params.fetch("path_id")
    the_<%= singular_table_name.underscore %> = <%= class_name.singularize %>.where({ :id => the_id }).at(0)

<% attributes.each do |attribute| -%>
<% if [:check_box, :checkbox].include?(attribute.field_type) -%>
    the_<%= singular_table_name.underscore %>.<%= attribute.column_name %> = params.fetch("<%= attribute.column_name %>_param", false)
<% else -%>
    the_<%= singular_table_name.underscore %>.<%= attribute.column_name %> = params.fetch("<%= attribute.column_name %>_param")
<% end -%>
<% end -%>

<% unless skip_validation_alerts? -%>
    if the_<%= singular_table_name.underscore %>.valid?
      the_<%= singular_table_name.underscore %>.save
      redirect_to("/<%= plural_table_name.underscore %>/#{the_<%= singular_table_name.underscore %>.id}", { :notice => "<%= singular_table_name.humanize %> updated successfully." } )
    else
      redirect_to("/<%= plural_table_name.underscore %>/#{the_<%= singular_table_name.underscore %>.id}", { :alert => the_<%= singular_table_name.underscore %>.errors.full_messages.to_sentence })
    end
<% else -%>
    the_<%= singular_table_name.underscore %>.save

<% unless skip_redirect? -%>
    redirect_to("/<%= plural_table_name.underscore %>/#{the_<%= singular_table_name.underscore %>.id}")
<% else -%>
      render({ :template => "<%= singular_table_name.underscore %>_templates/show" })
  <% end -%>
<% end -%>
  end

  def destroy
    the_id = params.fetch("path_id")
    the_<%= singular_table_name.underscore %> = <%= class_name.singularize %>.where({ :id => the_id }).at(0)

    the_<%= singular_table_name.underscore %>.destroy

<% unless skip_validation_alerts? -%>
    redirect_to("/<%= plural_table_name.underscore %>", { :notice => "<%= singular_table_name.humanize %> deleted successfully." } )
<% else -%>
<% unless skip_redirect? -%>
    redirect_to("/<%= plural_table_name.underscore %>")
<% else -%>
    @remaining_count = <%= class_name.singularize %>.count
    
    redirect_to("/<%= plural_table_name.underscore %>", { :notice => "<%= singular_table_name.humanize %> deleted successfully."} )    
<% end -%>
<% end -%>
  end
end

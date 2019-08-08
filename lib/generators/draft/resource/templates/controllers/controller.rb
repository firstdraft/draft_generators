class <%= plural_table_name.camelize %>Controller < ApplicationController
  def index
    @<%= plural_table_name.underscore %> = <%= class_name.singularize %>.all
    
    respond_to do |format|
      format.json do
        render({ :json => @<%= plural_table_name.underscore %>.as_json })
      end

      format.html do
        render({ :template => "<%= plural_table_name.underscore %>/index.html.erb" })
      end
    end
  end

  def show
    the_id = params.fetch(:rt_<%= singular_table_name %>_id)
    @<%= singular_table_name.underscore %> = <%= class_name.singularize %>.where({:id => the_id }).first

    respond_to do |format|
      format.json do
        render({ :json => @<%= singular_table_name.underscore %>.as_json })
      end

      format.html do
        render({ :template => "<%= plural_table_name.underscore %>/show.html.erb" })
      end
    end
  end

  def create
    @<%= singular_table_name.underscore %> = <%= class_name.singularize %>.new

<% attributes.each do |attribute| -%>
    @<%= singular_table_name.underscore %>.<%= attribute.column_name %> = params.fetch("<%= attribute.column_name %>", nil)
<% end -%>

<% unless skip_validation_alerts? -%>
    if @<%= singular_table_name.underscore %>.valid?
      @<%= singular_table_name.underscore %>.save
      respond_to do |format|
        format.json do
          render({ :json => @<%= singular_table_name.underscore %>.as_json })
        end
  
        format.html do
          redirect_back({ :fallback_location => "/<%= plural_table_name.underscore %>/<%= singular_table_name %>", :notice => "<%= singular_table_name.humanize %> created successfully."})
        end
      end
      redirect_back(:fallback_location => "/<%= @plural_table_name.underscore %>", {:notice => "<%= singular_table_name.humanize %> created successfully."})
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

  def update
    the_id = params.fetch(:rt_<%= singular_table_name %>_id)
    @<%= singular_table_name.underscore %> = <%= class_name.singularize %>.where(:id => the_id).at(0)

<% attributes.each do |attribute| -%>
    @<%= singular_table_name.underscore %>.<%= attribute.column_name %> = params.fetch(:<%= attribute.column_name %>, @<%= singular_table_name.underscore %><.%= attribute.column_name %>)
<% end -%>

<% unless skip_validation_alerts? -%>
    if @<%= singular_table_name.underscore %>.valid?
      @<%= singular_table_name.underscore %>.save
      respond_to do |format|
        format.json do
          render({ :json => @<%= singular_table_name.underscore %>.as_json })
        end
  
        format.html do
          redirect_to("/<%= @plural_table_name.underscore %>/#{@<%= singular_table_name.underscore %>.id}", {:notice => "<%= singular_table_name.humanize %> updated successfully."})
        end
    else
      # render("<%= singular_table_name.underscore %>_templates/edit_form_with_errors.html.erb")
      respond_to do |format|
        format.json do
          render({ :json => @<%= singular_table_name.underscore %>.as_json })
        end
  
        format.html do
          render({ :template => "<%= plural_table_name.underscore %>/show.html.erb" })
        end
    end
<% else -%>
    @<%= singular_table_name.underscore %>.save

<% unless skip_redirect? -%>
    redirect_to("/<%= @plural_table_name.underscore %>/#{@<%= singular_table_name.underscore %>.id}")
<% else -%>
  respond_to do |format|
    format.json do
      render({ :json => @<%= singular_table_name.underscore %>.as_json })
    end

    format.html do
      render({ :template => "<%= plural_table_name.underscore %>/show.html.erb" })
    end<% end -%>
<% end -%>
  end

  def destroy
    @<%= singular_table_name.underscore %> = <%= class_name.singularize %>.find(params.fetch("rt_<%= singular_table_name %>_id"))

    @<%= singular_table_name.underscore %>.destroy

<% unless skip_validation_alerts? -%>
    redirect_to("/<%= @plural_table_name.underscore %>", {:notice => "<%= singular_table_name.humanize %> deleted successfully."})
<% else -%>
<% unless skip_redirect? -%>
    redirect_to("/<%= @plural_table_name.underscore %>")
<% else -%>
    @remaining_count = <%= class_name.singularize %>.count
    
    respond_to do |format|
      format.json do
        render({ :json => @<%= singular_table_name.underscore %>.as_json })
      end

      format.html do
        redirect_to("/<%= @plural_table_name.underscore %>", {:notice => "<%= singular_table_name.humanize %> deleted successfully."})
      end
    render("<%= singular_table_name.underscore %>_templates/destroy_row.html.erb")
<% end -%>
<% end -%>
  end
end

<% total_bugs = rand(2) + 4 -%>
<% bugs_created = 0 -%>
class <%= plural_table_name.camelize %>Controller < ApplicationController
  def index
<% if buggy? && bugs_created < total_bugs && create_bug?(likelihood: :high) -%>
  <% bug_option = rand(2) + 1 -%>
  <% if bug_option == 1 -%>
@<%= plural_table_name.underscore %> = <%= class_name.singularize.downcase %>.all
  <% elsif bug_option == 2 -%>
<%= plural_table_name.underscore %> = <%= class_name.singularize %>.all
  <% end -%>
  <% bugs_created += 1 -%>
<% else -%>
    @<%= plural_table_name.underscore %> = <%= class_name.singularize %>.all
<% end -%>

    render("<%= singular_table_name.underscore %>_templates/index.html.erb")
  end

  def show
<% if buggy? && bugs_created < total_bugs && create_bug?(likelihood: :high) -%>
<% bug_option = rand(3) + 1 -%>
<% if bug_option == 1 -%>
    <%= singular_table_name.underscore %> = <%= class_name.singularize %>.find(params.fetch("id_to_display"))
<% elsif bug_option == 2 -%>
    @<%= singular_table_name.underscore %> = <%= class_name.singularize.downcase %>.find(params.fetch("id_to_display"))
<% elsif bug_option == 3 -%>
    @<%= singular_table_name.underscore %> = <%= class_name.singularize %>.find(params.fetch(id_to_display))
<% end -%>
<% bugs_created += 1 -%>
<% else -%>
    @<%= singular_table_name.underscore %> = <%= class_name.singularize %>.find(params.fetch("id_to_display"))
<% end -%>

    render("<%= singular_table_name.underscore %>_templates/show.html.erb")
  end

  def new_form
<% unless skip_validation_alerts? -%>
    @<%= singular_table_name.underscore %> = <%= class_name.singularize %>.new
<% end -%>

    render("<%= singular_table_name.underscore %>_templates/new_form.html.erb")
  end

  def create_row
<% if buggy? && bugs_created < total_bugs && create_bug?(likelihood: :high) -%>
<% bug_option = rand(3) + 1 -%>
<% if bug_option == 1 -%>
    <%= singular_table_name.underscore %> = <%= class_name.singularize %>.new
<% attributes.each do |attribute| -%>
    @<%= singular_table_name.underscore %>.<%= attribute.column_name %> = params.fetch("<%= attribute.column_name %>")
<% end -%>
<% elsif bug_option == 2 -%>
    @<%= singular_table_name.underscore %> = <%= class_name.singularize %>.new
<% attributes.each do |attribute| -%>
    @<%= singular_table_name.underscore %>.<%= attribute.column_name %> = params.fetch("the_<%= attribute.column_name %>")
<% end -%>
<% elsif bug_option == 3 -%>
    @<%= singular_table_name.underscore %> = <%= class_name.singularize %>.new
<% attributes.each do |attribute| -%>
    @<%= singular_table_name.underscore %>.<%= attribute.column_name %> = params.fetch(<%= attribute.column_name %>)
<% end -%>
<% end -%>
<% bugs_created += 1 -%>
<% else -%>
    @<%= singular_table_name.underscore %> = <%= class_name.singularize %>.new
<% attributes.each do |attribute| -%>
    @<%= singular_table_name.underscore %>.<%= attribute.column_name %> = params.fetch("<%= attribute.column_name %>")
<% end -%>
<% end -%>

<% unless skip_validation_alerts? -%>
    save_status = @<%= singular_table_name.underscore %>.save

    if save_status == true
      redirect_to("/<%= @plural_table_name.underscore %>", :notice => "<%= singular_table_name.humanize %> created successfully.")
    else
      render("<%= singular_table_name.underscore %>_templates/new_form.html.erb")
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
<% if buggy? && bugs_created < total_bugs && create_bug?(likelihood: :high) -%>
<% bug_option = rand(3) + 1 -%>
<% if bug_option == 1 -%>
    <%= singular_table_name.underscore %> = <%= class_name.singularize %>.find(params.fetch("id_to_display"))
<% elsif bug_option == 2 -%>
    @<%= singular_table_name.underscore %> = <%= class_name.singularize.downcase %>.find(params.fetch("id_to_display"))
<% elsif bug_option == 3 -%>
    @<%= singular_table_name.underscore %> = <%= class_name.singularize %>.find(params.fetch(id_to_display))
<% end -%>
<% bugs_created += 1 -%>
<% else -%>
    @<%= singular_table_name.underscore %> = <%= class_name.singularize %>.find(params.fetch("id_to_display"))
<% end -%>

    render("<%= singular_table_name.underscore %>_templates/edit_form.html.erb")
  end

  def update_row
<% if buggy? && bugs_created < total_bugs && create_bug?(likelihood: :high) -%>
<% bug_option = rand(3) + 1 -%>
<% if bug_option == 1 -%>
    @<%= singular_table_name.underscore %> = <%= class_name.singularize %>.new
<% elsif bug_option == 2 -%>
    @<%= singular_table_name.underscore %> = <%= class_name.singularize.downcase %>.find(params.fetch("id_to_modify"))
<% elsif bug_option == 3 -%>
    <%= singular_table_name.underscore %> = <%= class_name.singularize %>.find(params.fetch(id_to_modify))
<% end -%>
<% bugs_created += 1 -%>
<% else -%>
    @<%= singular_table_name.underscore %> = <%= class_name.singularize %>.find(params.fetch("id_to_modify"))
<% end -%>

<% attributes.each do |attribute| -%>
    @<%= singular_table_name.underscore %>.<%= attribute.column_name %> = params.fetch("<%= attribute.column_name %>")
<% end -%>

<% unless skip_validation_alerts? -%>
    save_status = @<%= singular_table_name.underscore %>.save

    if save_status == true
      redirect_to("/<%= @plural_table_name.underscore %>/#{@<%= singular_table_name.underscore %>.id}", :notice => "<%= singular_table_name.humanize %> updated successfully.")
    else
      render("<%= singular_table_name.underscore %>_templates/edit_form.html.erb")
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
<% if buggy? && bugs_created < total_bugs && create_bug?(likelihood: :high) -%>
<% bug_option = rand(2) + 1 -%>
<% if bug_option == 1 -%>
    @<%= singular_table_name.underscore %> = <%= class_name.singularize %>.find(params.fetch("id_to_remove"))
<% elsif bug_option == 2 -%>
    <%= singular_table_name.underscore %> = <%= class_name.singularize %>.find(params.fetch("id_to_remove"))

    <%= singular_table_name.underscore %>.destroy
<% end -%>
<% bugs_created += 1 -%>
<% else -%>
    @<%= singular_table_name.underscore %> = <%= class_name.singularize %>.find(params.fetch("id_to_remove"))

    @<%= singular_table_name.underscore %>.destroy
<% end -%>

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

<% puts "#{bugs_created} controller bugs created" %>

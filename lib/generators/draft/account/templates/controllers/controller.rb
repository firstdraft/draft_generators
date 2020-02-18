class <%= class_name.pluralize %>Controller < ApplicationController
  # skip_before_action(:force_<%= singular_table_name.underscore %>_sign_in, { :only => [:new_registration_form, :create] })
  
  def new_registration_form
    render({ :template => "<%=singular_table_name.underscore %>_sessions/sign_up.html.erb" })
  end

  def create
    @<%= singular_table_name.underscore %> = <%= class_name.singularize %>.new
<% attributes.each do |attribute| -%>
<% if attribute.field_type == :check_box -%>
    @<%= singular_table_name.underscore %>.<%= attribute.column_name %> = params.fetch("query_<%= attribute.column_name %>", false)
<% elsif attribute.column_name != "password_digest" -%>
    @<%= singular_table_name.underscore %>.<%= attribute.column_name %> = params.fetch("query_<%= attribute.column_name %>")
<% else -%>
    @<%= singular_table_name.underscore %>.password = params.fetch("query_password")
    @<%= singular_table_name.underscore %>.password_confirmation = params.fetch("query_password_confirmation")
<% end -%>
<% end -%>

    save_status = @<%= singular_table_name.underscore %>.save

    if save_status == true
      session.store(:<%= singular_table_name.underscore %>_id,  @<%= singular_table_name.underscore %>.id)
   
      redirect_to("/", { :notice => "<%= singular_table_name.humanize %> account created successfully."})
    else
      redirect_to("/<%=singular_table_name.underscore %>_sign_up", { :alert => "<%= singular_table_name.humanize %> account failed to create successfully."})
    end
  end
    
  def edit_registration_form
    render({ :template => "<%= plural_table_name.underscore %>/edit_profile.html.erb" })
  end

  def update
    @<%= singular_table_name.underscore %> = @current_<%= singular_table_name.underscore %>
<% attributes.each do |attribute| -%>
<% if attribute.field_type == :check_box -%>
    @<%= singular_table_name.underscore %>.<%= attribute.column_name %> = params.fetch("query_<%= attribute.column_name %>", false)
<% elsif attribute.column_name != "password_digest" -%>
    @<%= singular_table_name.underscore %>.<%= attribute.column_name %> = params.fetch("query_<%= attribute.column_name %>")
<% else -%>
    @<%= singular_table_name.underscore %>.password = params.fetch("query_password")
    @<%= singular_table_name.underscore %>.password_confirmation = params.fetch("query_password_confirmation")
<% end -%>
<% end -%>
    
    if @<%= singular_table_name.underscore %>.valid?
      @<%= singular_table_name.underscore %>.save

      redirect_to("/", { :notice => "<%= singular_table_name.humanize %> account updated successfully."})
    else
      render({ :template => "<%= plural_table_name.underscore %>/edit_profile_with_errors.html.erb" })
    end
  end

  def destroy
    @current_<%= singular_table_name.underscore %>.destroy
    reset_session
    
    redirect_to("/", { :notice => "<%= class_name.singularize %> account cancelled" })
  end
  
end

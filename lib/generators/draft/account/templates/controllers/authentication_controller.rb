class <%= class_name.singularize %>AuthenticationController < ApplicationController
  # Uncomment line 3 in this file and line 5 in ApplicationController if you want to force <%= plural_table_name %> to sign in before any other actions.
  # skip_before_action(:force_<%= singular_table_name.underscore %>_sign_in, { :only => [:sign_up_form, :create, :sign_in_form, :create_cookie] })

  def sign_in_form
    render({ :template => "<%= singular_table_name.underscore %>_authentication/sign_in" })
  end

  def create_cookie
    <%= singular_table_name.underscore %> = <%= class_name.singularize %>.where({ :email => params.fetch("query_email") }).first
    
    the_supplied_password = params.fetch("query_password")
    
    if <%= singular_table_name.underscore %> != nil
      are_they_legit = <%= singular_table_name.underscore %>.authenticate(the_supplied_password)
    
      if are_they_legit == false
        redirect_to("/<%= singular_table_name.underscore %>_sign_in", { :alert => "Incorrect password." })
      else
        session.store(:<%= singular_table_name.underscore %>_id, <%= singular_table_name.underscore %>.id)
      
        redirect_to("/", { :notice => "Signed in successfully." })
      end
    else
      redirect_to("/<%= singular_table_name.underscore %>_sign_in", { :alert => "No <%= singular_table_name.underscore %> with that email address." })
    end
  end

  def destroy_cookies
    reset_session

    redirect_to("/", { :notice => "Signed out successfully." })
  end

  def sign_up_form
    render({ :template => "<%= singular_table_name.underscore %>_authentication/sign_up" })
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
      session.store(:<%= singular_table_name.underscore %>_id, @<%= singular_table_name.underscore %>.id)
   
      redirect_to("/", { :notice => "<%= singular_table_name.humanize %> account created successfully."})
    else
      redirect_to("/<%= singular_table_name.underscore %>_sign_up", { :alert => @<%= singular_table_name%>.errors.full_messages.to_sentence })
    end
  end
    
  def edit_profile_form
    render({ :template => "<%= singular_table_name.underscore %>_authentication/edit_profile" })
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
      render({ :template => "<%= singular_table_name.underscore %>_authentication/edit_profile_with_errors" , :alert => @<%= singular_table_name%>.errors.full_messages.to_sentence })
    end
  end

  def destroy
    @current_<%= singular_table_name.underscore %>.destroy
    reset_session
    
    redirect_to("/", { :notice => "<%= class_name.singularize %> account cancelled" })
  end
 
end

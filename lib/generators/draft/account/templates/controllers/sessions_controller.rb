class <%= class_name.singularize %>SessionsController < ApplicationController
  skip_before_action(:force_<%= singular_table_name.underscore %>_sign_in, { :only => [:new_session_form, :add_cookie] })

  def new_session_form
    render({ :template => "<%=singular_table_name.underscore %>_sessions/sign_in.html.erb" })
  end

  def add_cookie
    <%=singular_table_name.underscore %> = <%= class_name.singularize %>.where({ :email => params.fetch("email_from_query") }).at(0)
    
    the_supplied_password = params.fetch("password_from_query")
    
    if <%=singular_table_name.underscore %> != nil
      are_they_legit = <%=singular_table_name.underscore %>.authenticate(the_supplied_password)
    
      if are_they_legit == false
        redirect_to("/<%=singular_table_name.underscore %>_sign_in", { :alert => "Password incorrect." })
      else
        session.store(:<%=singular_table_name.underscore %>_id, <%=singular_table_name.underscore %>.id)
      
        redirect_to("/", { :notice => "Signed in successfully." })
      end
    else
      redirect_to("/<%=singular_table_name.underscore %>_sign_in", { :alert => "There's no <%=singular_table_name.underscore %> account with that email address." })
    end
  end

  def remove_cookies
    reset_session

    redirect_to("/", { :notice => "Signed out successfully." })
  end
 
end

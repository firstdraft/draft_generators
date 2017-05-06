class <%= plural_table_name.camelize %>Controller < ApplicationController
  def index
    @<%= plural_table_name.underscore %> = <%= class_name %>.all
  end

  def show
    @<%= singular_table_name.underscore %> = <%= class_name %>.find(params[:id])
  end
end

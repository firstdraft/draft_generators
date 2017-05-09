class <%= plural_table_name.camelize %>Controller < ApplicationController
  def index
    @<%= plural_table_name.underscore %> = <%= class_name.singularize %>.all
  end

  def show
    @<%= singular_table_name.underscore %> = <%= class_name.singularize %>.find(params[:id])
  end
end

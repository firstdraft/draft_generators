# frozen_string_literal: true

module DraftGenerators
  class RailsTagService
    def self.text_input(field_name)
      %{<%= f.text_field :#{field_name}, :class => "form-control", :placeholder => "Enter #{field_name.gsub("_", " ")}" %>}
    end

    def self.text_area_input(field_name)
      %{<%= f.text_area :#{field_name}, :class => "form-control", :placeholder => "Enter #{field_name.gsub("_", " ")}" %>}
    end

    def self.number_field(field_name)
      %{<%= f.number_field :#{field_name}, :class => "form-control", :placeholder => "Enter #{field_name.gsub("_", " ")}" %>}
    end

    def self.date_select(field_name)
      %{<%= f.date_select :#{field_name}, class: "col-sm-2 control-label" %>}
    end

    def self.datetime_select(field_name)
      %{<%= f.datetime_select :#{field_name}, class: "col-sm-2 control-label" %>}
    end

    def self.check_box(field_name)
      %{<%= f.check_box :#{field_name}, class: "col-sm-2 control-label" %>}
    end

    def self.time_select(field_name)
      %{<%= f.time_select :#{field_name}, class: "col-sm-2 control-label" %>}
    end

    def self.input_tag(column)
      case column.type.to_s
      when "datetime"; datetime_select(column.name)
      when "date"; date_select(column.name)
      when "time"; time_select(column.name)
      when "boolean"; check_box(column.name)
      when "string"; text_input(column.name)
      when "text"; text_area_input(column.name)
      when "decimal", "integer"; number_field(column.name)
      else
        text_input(column.name)
      end
    end
  end
end

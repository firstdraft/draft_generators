# frozen_string_literal: true

module DraftGenerators
  class RailsTagService
    def self.text_input(field_name)
      %{<%= f.text_field :#{field_name}, :class => #{field_name}_class, :placeholder => "Enter #{field_name.gsub("_", " ")}" %>}
    end

    def self.text_area_input(field_name)
      %{<%= f.text_area :#{field_name}, :class => #{field_name}_class, :placeholder => "Enter #{field_name.gsub("_", " ")}" %>}
    end

    def self.number_field(field_name)
      %{<%= f.number_field :#{field_name}, :class => #{field_name}_class, :placeholder => "Enter #{field_name.gsub("_", " ")}" %>}
    end

    def self.date_select(field_name)
      %{<%= f.date_select :#{field_name}, class: "\#\{#{field_name}_class\} col-sm-2" %>}
    end

    def self.datetime_select(field_name)
      %{<%= f.datetime_select :#{field_name}, class: "\#\{#{field_name}_class\} col-sm-2" %>}
    end

    def self.check_box(field_name)
      %{<%= f.check_box :#{field_name}, class: "\#\{#{field_name}_class\} col-sm-2" %>}
    end

    def self.time_select(field_name)
      %{<%= f.time_select :#{field_name}, class: "\#\{#{field_name}_class\} col-sm-2" %>}
    end

    def self.input_tag(column)
      name = column.name
      case column.type.to_s
      when "datetime"; datetime_select(name)
      when "date"; date_select(name)
      when "time"; time_select(name)
      when "boolean"; check_box(name)
      when "text"; text_area_input(name)
      when "decimal", "integer"; number_field(name)
      else
        text_input(name)
      end
    end
  end
end

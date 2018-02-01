# Copy this file into your spec/support folder; create one if you don't have it.
# https://github.com/firstdraft/increasing_random/blob/master/increasing_random.rb

require Rails.root.join("spec", "support", "increasing_random.rb")

FactoryBot.define do
  factory :<%= singular_table_name %> do
    sequence(:id, IncreasingRandom.new) { |n| n.value }
<% attributes.each do |attribute| -%>
<% case attribute.type -%>
<% when :belongs_to, :references -%>
    association :<%= attribute.name %>
<% when :boolean -%>
    <%= attribute.column_name %> false
<% when :date -%>
    sequence(:<%= attribute.column_name %>, Date.today)
<% when :datetime -%>
    <%= attribute.column_name %> Time.now
<% when :decimal -%>
    <%= attribute.column_name %> 42.42
<% when :integer, :primary_key -%>
    sequence(:<%= attribute.column_name %>, IncreasingRandom.new) { |n| n.value }
<% when :string, :text -%>
    sequence(:<%= attribute.column_name %>, IncreasingRandom.new) { |n| "Some fake <%= attribute.human_name.downcase %> #{n}" }
<% when :time -%>
    <%= attribute.column_name %> Time.now.beginning_of_day
<% when :timestamp -%>
    <%= attribute.column_name %> Time.now
<% else -%>
    sequence(:<%= attribute.column_name %>, IncreasingRandom.new) { |n| "Some fake <%= attribute.human_name.downcase %> #{n}" }
<% end -%>
<% end -%>
  end
end

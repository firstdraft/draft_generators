require "rails_helper"

feature "<%= plural_table_name.humanize.upcase %>" do
<% attributes.each do |attribute| -%>
  describe "/<%= plural_table_name %>" do
    it "has the <%= attribute.human_name.downcase %> of every row", points: 5 do
      test_<%= plural_table_name %> = create_list(:<%= singular_table_name %>, 5)

      visit "/<%= plural_table_name %>"

      test_<%= plural_table_name %>.each do |current_<%= singular_table_name %>|
        expect(page).to have_content(current_<%= singular_table_name %>.<%= attribute.column_name %>)
      end
    end
  end

<% end -%>
  describe "/<%= plural_table_name %>" do
    it "has a link to the details page of every row", points: 5 do
      test_<%= plural_table_name %> = create_list(:<%= singular_table_name %>, 5)

      visit "/<%= plural_table_name %>"

      test_<%= plural_table_name %>.each do |current_<%= singular_table_name %>|
        expect(page).to have_css("a[href*='#{current_<%= singular_table_name %>.id}']", text: "Show details")
      end
    end
  end

<% attributes.each do |attribute| -%>
  describe "/<%= plural_table_name %>/[<%= singular_table_name.humanize.upcase %> ID]" do
    it "has the correct <%= attribute.human_name.downcase %>", points: 3 do
      <%= singular_table_name %>_to_show = create(:<%= singular_table_name %>)

      visit "/<%= plural_table_name %>"
      find("a[href*='#{<%= singular_table_name %>_to_show.id}']", text: "Show details").click

      expect(page).to have_content(<%= singular_table_name %>_to_show.<%= attribute.column_name %>)
    end
  end

<% end -%>
  describe "/<%= plural_table_name %>" do
    it "has a link to the new <%= singular_table_name.humanize.downcase %> page", points: 2 do
      visit "/<%= plural_table_name %>"

      expect(page).to have_css("a", text: "Add a new <%= singular_table_name.humanize.downcase %>")
    end
  end

<% attributes.each do |attribute| -%>
  describe "/<%= plural_table_name %>/new" do
    it "saves the <%= attribute.human_name.downcase %> when submitted", points: 2, hint: h("label_for_input") do
      visit "/<%= plural_table_name %>"
      click_on "Add a new <%= singular_table_name.humanize.downcase %>"

<% case attribute.type -%>
<% when :belongs_to, :references -%>
      test_<%= attribute.name %> = create(:<%= attribute.name %>)
      fill_in "<%= attribute.human_name %>", with: test_<%= attribute.name %>.id
<% when :boolean -%>
      test_<%= attribute.column_name %> = <%= !attribute.default %>
      check "<%= attribute.human_name %>"
<% when :date -%>
      test_<%= attribute.column_name %> = 2.weeks.from_now.to_date
      fill_in "<%= attribute.human_name %>", with: test_<%= attribute.column_name %>
<% when :datetime -%>
      test_<%= attribute.column_name %> = 2.days.from_now.to_datetime.beginning_of_minute
      fill_in "<%= attribute.human_name %>", with: test_<%= attribute.column_name %>
<% when :decimal -%>
      test_<%= attribute.column_name %> = rand.round(4) * 100
      fill_in "<%= attribute.human_name %>", with: test_<%= attribute.column_name %>
<% when :integer, :primary_key -%>
      test_<%= attribute.column_name %> = rand(1000)
      fill_in "<%= attribute.human_name %>", with: test_<%= attribute.column_name %>
<% when :string, :text -%>
      test_<%= attribute.column_name %> = "A fake <%= attribute.human_name.downcase %> I'm typing at #{Time.now}"
      fill_in "<%= attribute.human_name %>", with: test_<%= attribute.column_name %>
<% when :time -%>
      test_<%= attribute.column_name %> = 2.hours.from_now.to_time.round.change(year: 2000, month: 1, day: 1)
      fill_in "<%= attribute.human_name %>", with: test_<%= attribute.column_name %>
<% when :timestamp -%>
      test_<%= attribute.column_name %> = 2.days.from_now.to_datetime.beginning_of_minute
      fill_in "<%= attribute.human_name %>", with: test_<%= attribute.column_name %>
<% else -%>
      test_<%= attribute.column_name %> = "A fake <%= attribute.human_name.downcase %> I'm typing at #{Time.now}"
      fill_in "<%= attribute.human_name %>", with: test_<%= attribute.column_name %>
<% end -%>

      click_on "Create <%= singular_table_name.humanize.downcase %>"

      last_<%= singular_table_name %> = <%= singular_table_name.camelize %>.order(created_at: :asc).last
<% case attribute.type -%>
<% when :belongs_to, :references -%>
      expect(last_<%= singular_table_name %>.<%= attribute.name %>).to eq(test_<%= attribute.name %>)
<% else -%>
      expect(last_<%= singular_table_name %>.<%= attribute.column_name %>).to eq(test_<%= attribute.column_name %>)
<% end -%>
    end
  end

<% end -%>
<% unless skip_redirect? -%>
  describe "/<%= plural_table_name %>/new" do
    it "redirects to the index when submitted", points: 2, hint: h("redirect_vs_render") do
      visit "/<%= plural_table_name %>"
      click_on "Add a new <%= singular_table_name.humanize.downcase %>"

      click_on "Create <%= singular_table_name.humanize.downcase %>"

      expect(page).to have_current_path("/<%= plural_table_name %>")
    end
  end

  describe "/<%= plural_table_name %>/new" do
    it "redirects to the details page with a notice", points: 3, hint: h("copy_must_match") do
      visit "/<%= plural_table_name %>"

      expect(page).to_not have_content("<%= singular_table_name.humanize %> created successfully.")

      click_on "Add a new <%= singular_table_name.humanize.downcase %>"
      click_on "Create <%= singular_table_name.humanize.downcase %>"

      expect(page).to have_content("<%= singular_table_name.humanize %> created successfully.")
    end
  end

<% end -%>
  describe "/<%= plural_table_name %>/[<%= singular_table_name.humanize.upcase %> ID]" do
    it "has a 'Delete <%= singular_table_name.humanize.downcase %>' link", points: 2 do
      <%= singular_table_name %>_to_delete = create(:<%= singular_table_name %>)

      visit "/<%= plural_table_name %>"
      find("a[href*='#{<%= singular_table_name %>_to_delete.id}']", text: "Show details").click

      expect(page).to have_css("a", text: "Delete")
    end
  end

  describe "/delete_<%= singular_table_name %>/[<%= singular_table_name.humanize.upcase %> ID]" do
    it "removes a row from the table", points: 5 do
      <%= singular_table_name %>_to_delete = create(:<%= singular_table_name %>)

      visit "/<%= plural_table_name %>"
      find("a[href*='#{<%= singular_table_name %>_to_delete.id}']", text: "Show details").click
      click_on "Delete <%= singular_table_name.humanize.downcase %>"

      expect(<%= singular_table_name.camelize %>.exists?(<%= singular_table_name %>_to_delete.id)).to be(false)
    end
  end

<% unless skip_redirect? -%>
  describe "/delete_<%= singular_table_name %>/[<%= singular_table_name.humanize.upcase %> ID]" do
    it "redirects to the index", points: 3, hint: h("redirect_vs_render") do
      <%= singular_table_name %>_to_delete = create(:<%= singular_table_name %>)

      visit "/<%= plural_table_name %>"
      find("a[href*='#{<%= singular_table_name %>_to_delete.id}']", text: "Show details").click
      click_on "Delete <%= singular_table_name.humanize.downcase %>"

      expect(page).to have_current_path("/<%= plural_table_name %>")
    end
  end

  describe "/delete_<%= singular_table_name %>/[<%= singular_table_name.humanize.upcase %> ID]" do
    it "redirects to the index with a notice", points: 3, hint: h("copy_must_match") do
      <%= singular_table_name %>_to_delete = create(:<%= singular_table_name %>)

      visit "/<%= plural_table_name %>"
      find("a[href*='#{<%= singular_table_name %>_to_delete.id}']", text: "Show details").click

      expect(page).to_not have_content("<%= singular_table_name.humanize %> deleted successfully.")

      click_on "Delete <%= singular_table_name.humanize.downcase %>"

      expect(page).to have_content("<%= singular_table_name.humanize %> deleted successfully.")
    end
  end

<% end -%>
  describe "/<%= plural_table_name %>/[<%= singular_table_name.humanize.upcase %> ID]" do
    it "has an 'Edit <%= singular_table_name.humanize.downcase %>' link", points: 5 do
      <%= singular_table_name %>_to_edit = create(:<%= singular_table_name %>)

      visit "/<%= plural_table_name %>"
      find("a[href*='#{<%= singular_table_name %>_to_edit.id}']", text: "Show details").click

      expect(page).to have_css("a", text: "Edit <%= singular_table_name.humanize.downcase %>")
    end
  end

<% attributes.each do |attribute| -%>
  describe "/<%= plural_table_name %>/[<%= singular_table_name.humanize.upcase %> ID]/edit" do
    it "has <%= attribute.human_name.downcase %> pre-populated", points: 3, hint: h("value_attribute") do
      <%= singular_table_name %>_to_edit = create(:<%= singular_table_name %>)

      visit "/<%= plural_table_name %>"
      find("a[href*='#{<%= singular_table_name %>_to_edit.id}']", text: "Show details").click
      click_on "Edit <%= singular_table_name.humanize.downcase %>"

<% case attribute.field_type -%>
<% when :check_box -%>
<% when :text_area -%>
      expect(page).to have_content(<%= singular_table_name %>_to_edit.<%= attribute.column_name %>)
<% else -%>
      expect(page).to have_css("input[value='#{<%= singular_table_name %>_to_edit.<%= attribute.column_name %>}']")
<% end -%>
    end
  end

<% end -%>
<% attributes.each do |attribute| -%>
  describe "/<%= plural_table_name %>/[<%= singular_table_name.humanize.upcase %> ID]/edit" do
    it "updates <%= attribute.human_name.downcase %> when submitted", points: 5, hint: h("label_for_input button_type") do
      <%= singular_table_name %>_to_edit = create(:<%= singular_table_name %>, <%= attribute.column_name %>: "Boring old <%= attribute.human_name.downcase %>")

      visit "/<%= plural_table_name %>"
      find("a[href*='#{<%= singular_table_name %>_to_edit.id}']", text: "Show details").click
      click_on "Edit <%= singular_table_name.humanize.downcase %>"

<% case attribute.type -%>
<% when :belongs_to, :references -%>
      test_<%= attribute.name %> = create(:<%= attribute.name %>)
      fill_in "<%= attribute.human_name %>", with: test_<%= attribute.name %>.id
<% when :boolean -%>
      test_<%= attribute.column_name %> = true
      check "<%= attribute.human_name %>"
<% when :date -%>
      test_<%= attribute.column_name %> = 2.weeks.from_now.to_date
      fill_in "<%= attribute.human_name %>", with: test_<%= attribute.column_name %>
<% when :datetime -%>
      test_<%= attribute.column_name %> = 2.days.from_now.to_datetime.beginning_of_minute
      fill_in "<%= attribute.human_name %>", with: test_<%= attribute.column_name %>
<% when :decimal -%>
      test_<%= attribute.column_name %> = rand.round(4) * 100
      fill_in "<%= attribute.human_name %>", with: test_<%= attribute.column_name %>
<% when :integer, :primary_key -%>
      test_<%= attribute.column_name %> = rand(1000)
      fill_in "<%= attribute.human_name %>", with: test_<%= attribute.column_name %>
<% when :string, :text -%>
      test_<%= attribute.column_name %> = "Exciting new <%= attribute.human_name.downcase %> at #{Time.now}"
      fill_in "<%= attribute.human_name %>", with: test_<%= attribute.column_name %>
<% when :time -%>
      test_<%= attribute.column_name %> = 2.hours.from_now.to_time.round.change(year: 2000, month: 1, day: 1)
      fill_in "<%= attribute.human_name %>", with: test_<%= attribute.column_name %>
<% when :timestamp -%>
      test_<%= attribute.column_name %> = 2.days.from_now.to_datetime.beginning_of_minute
      fill_in "<%= attribute.human_name %>", with: test_<%= attribute.column_name %>
<% else -%>
      test_<%= attribute.column_name %> = "Exciting new <%= attribute.human_name.downcase %> at #{Time.now}"
      fill_in "<%= attribute.human_name %>", with: test_<%= attribute.column_name %>
<% end -%>

      click_on "Update <%= singular_table_name.humanize.downcase %>"

      <%= singular_table_name %>_as_revised = <%= singular_table_name.camelize %>.find(<%= singular_table_name %>_to_edit.id)

<% case attribute.type -%>
<% when :belongs_to, :references -%>
      expect(<%= singular_table_name %>_as_revised.<%= attribute.name %>).to eq(test_<%= attribute.name %>)
<% else -%>
      expect(<%= singular_table_name %>_as_revised.<%= attribute.column_name %>).to eq(test_<%= attribute.column_name %>)
<% end -%>
    end
  end

<% end -%>
<% unless skip_redirect? -%>
  describe "/<%= plural_table_name %>/[<%= singular_table_name.humanize.upcase %> ID]/edit" do
    it "redirects to the details page", points: 3, hint: h("embed_vs_interpolate redirect_vs_render") do
      <%= singular_table_name %>_to_edit = create(:<%= singular_table_name %>)

      visit "/<%= plural_table_name %>"
      find("a[href*='#{<%= singular_table_name %>_to_edit.id}']", text: "Show details").click
      details_page_path = page.current_path

      click_on "Edit <%= singular_table_name.humanize.downcase %>"
      click_on "Update <%= singular_table_name.humanize.downcase %>"

      expect(page).to have_current_path(details_page_path, only_path: true)
    end
  end

  describe "/<%= plural_table_name %>/[<%= singular_table_name.humanize.upcase %> ID]/edit" do
    it "redirects to the details page with a notice", points: 3, hint: h("copy_must_match") do
      <%= singular_table_name %>_to_edit = create(:<%= singular_table_name %>)

      visit "/<%= plural_table_name %>"
      find("a[href*='#{<%= singular_table_name %>_to_edit.id}']", text: "Show details").click

      expect(page).to_not have_content("<%= singular_table_name.humanize %> updated successfully.")

      click_on "Edit <%= singular_table_name.humanize.downcase %>"
      click_on "Update <%= singular_table_name.humanize.downcase %>"

      expect(page).to have_content("<%= singular_table_name.humanize %> updated successfully.")
    end
  end
<% end -%>
end

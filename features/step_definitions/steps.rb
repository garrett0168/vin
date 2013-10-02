When /^I visit "(.*)\s*"$/ do |uri|
  visit "#{uri}"
  sleep 0.5
end

When(/^I visit the home page$/) do
  visit "/"
  sleep 0.5
end

Then /^I should( not)? see "([^"]*)"\s*$/ do |negative, text|
  if negative then
    page.should_not have_xpath(".//*[contains(text(),\"#{text}\")]", :visible => true)
  else
    page.should have_content(text)
  end
end

When /^I fill in "([^"]*)" with "([^"]*)"$/ do |page_el, arg|
  fill_in page_el, :with => arg
end

Then /^(?:I )?(?:click|click on) "([^"]*)"\s*$/ do |the_link|
  click_link_or_button(the_link)
end

Given /^the following vehicles:$/ do |vehicles|
  vehicles.hashes.each do |vehicle| 
    FactoryGirl.create(:vehicle, vehicle)
  end
end

Then(/^I should see the following vehicles:$/) do |table|
  sleeping(2).seconds.between_tries.failing_after(5).tries do
    rows = find("#vin-history-table").all('tr')
    actual_table = rows.map { |r| r.all('th,td').map { |c| c.text.strip } }

    actual_table = Cucumber::Ast::Table.new actual_table
    table.diff!(actual_table, :surplus_row => true, :surplus_col => true)
  end
end

When(/^I click "Details" for VIN "(.*?)"$/) do |vin|
  within("#vin_#{vin}") { click_link_or_button("Details") }
end


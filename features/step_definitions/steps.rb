When /^I visit "(.*)\s*"$/ do |uri|
  visit "#{uri}"
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

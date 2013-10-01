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


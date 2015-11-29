#Background
Given /the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|
    Movie.create({:title => movie[:title], :rating => movie[:rating], :release_date => movie[:release_date]})
  end
end

# Make sure that one string (regexp) occurs before or after another one
#   on the same page

Then /I should see (.*) before (.*)/ do |e1, e2|
  within_table "movies" do
    match = /"#{e1}.*#{e2}"/m =~ page.body
  end
  #  ensure that that e1 occurs before e2.
  #  page.body is the entire content of the page as a string.
end

When /I check the following ratings: (.*)/ do |rating_list|
  rating_list.split(',').each do |rating|
      check("ratings[#{rating.gsub(' ','')}]")
  end
end

When /I uncheck the following ratings: (.*)/ do |rating_list|
  rating_list.split(',').each do |rating|
      uncheck("ratings[#{rating.gsub(' ','')}]")
  end
end

When /I click on (.*)$/ do |button|
  click_button("ratings_#{button}")
end

Then /I should see movies with the following ratings: (.*)$/ do |rating_list|
  rating_list.split(',').each do |rating|
    rating.gsub!(' ', '')
    within_table "movies" do
      expect(page).to have_content(rating)
    end
  end
end

Then /I should not see movies with the following ratings: (.*)$/ do |rating_list|
  rating_list.split(',').each do |rating|
    rating.gsub!(' ', '')
    within_table "movies" do
      expect(page).to have_no_content(rating)
    end
  end
end


Then /I should see all the movies/ do
  count = Movie.all.count
  page.all('table#movies tr').count.should == count + 1
end

# Add a declarative step here for populating the DB with movies.

Given /the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|
  Movie.create(movie)
    # each returned element will be a hash whose key is the table header.
    # you should arrange to add that movie to the database here.
  end
#flunk "Unimplemented"
end

# Make sure that one string (regexp) occurs before or after another one
#   on the same page

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  #  ensure that that e1 occurs before e2.
  #  page.content  is the entire content of the page as a string.
  flunk "Unimplemented"
end

# Make it easier to express checking or unchecking several boxes at once
#  "When I uncheck the following ratings: PG, G, R"
#  "When I check the following ratings: G"

When /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list|
  str_rating = rating_list.split
  str_rating.each do |rating|
   id = "ratings_#{rating}"
   if uncheck.nil?
    check(id)
   else
    uncheck(id)
   end
  end
  # Note: UnComment uncheck and check at final point
  # HINT: use String#split to split up the rating_list, then
  #   iterate over the ratings and reuse the "When I check..." or
  #   "When I uncheck..." steps in lines 89-95 of web_steps.rb
end

# For filter movie list feature
Then /I should see movies with ratings: (.*)/ do |rating_list|
 str_rating = rating_list.split
 movies = Movie.where("rating in (?,?)",str_rating[0],str_rating[1])
 movies.each do |movie|
  page.should have_content(movie.title)
 end
end

And /I should not see movies other than ratings: (.*)/ do |rating_list|
 str_rating = rating_list.split
 movies = Movie.where("rating not in (?,?)",str_rating[0],str_rating[1])
 movies.each do |movie|
  page.should have_no_content(movie.title)
 end
end

Given /^I (un)?check all ratings$/ do |uncheck|
 movies = Movie.select("distinct(rating)")
 movies.each do |movie|
  id = "ratings_#{movie.rating}"
  if uncheck.nil?
   check(id)
  else
   uncheck(id)
  end
 end
end

Then /^I should not see any movies$/ do
 page.should_not have_css("table#movies tbody tr",:count=>0)
end

Then /^I should see all the movies$/ do
 count = page.all("table#movies tbody tr").size
 count.should==Movie.count
end

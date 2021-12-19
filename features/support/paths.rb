# TL;DR: YOU SHOULD DELETE THIS FILE
#
# This file is used by web_steps.rb, which you should also delete
#
# You have been warned
module NavigationHelpers
  # Maps a name to a path. Used by the
  #
  #   When /^I go to (.+)$/ do |page_name|
  #
  # step definition in web_steps.rb
  #
  def path_to(page_name)
    case page_name

    when /^the (L'Books )?home\s?page$/ then '/'

    # Add more mappings here.
    # Here is an example that pulls values out of the Regexp:
    #
    #   when /^(.*)'s profile page$/i
    #     user_profile_path(User.find_by_login($1))
    
    when /^the dashboard page$/
      "/dashboard"

    when /^the results page for "(.*)"$/
      edit_book_path(Book.find_by_title($1).id)

    when /^the search results page$/
      search_path

    when /^the book view page for "(.*)"$/
      "/book/#{Book.find_by_title($1).id}"

    when /^the book view page for a book with ID "(.*)"$/
      "/book/#{$1}"
    
    when /^the listing creation page$/
      "/listing/new"
    
    when /^the listing view page for a listing with ID "(.*)"$/
      "/listing/#{$1}"

    when /^the listing deletion page for a listing with ID "(.*)"$/
      "/listing/#{$1}/delete"

    when /^the listing edit page for a listing with ID "(.*)"$/
      "/listing/#{$1}/edit"
    
    when /^the sold view page for a listing with ID "(.*)"$/
      "/listing/#{$1}/sold"
 
    when /^the rate selection page for a listing with ID "(.*)"$/
      "/listing/#{$1}/rate"

    when /^the bookmark page for a listing with ID "(.*)"$/
      "/listing/#{$1}/bookmark"
 
    when /^the listing page for the book with ISBN "(.*)" and description "(.*)"$/
      listing_path(Listing.find(isbn = $1, description = $2))

    when /^the logged in page$/
      root_path

    when /^the logged out page/
      "/logout"
      
    else
      begin
        page_name =~ /^the (.*) page$/
        path_components = $1.split(/\s+/)
        self.send(path_components.push('path').join('_').to_sym)
      rescue NoMethodError, ArgumentError
        raise "Can't find mapping from \"#{page_name}\" to a path.\n" +
          "Now, go and add a mapping in #{__FILE__}"
      end
    end
  end
end

World(NavigationHelpers)

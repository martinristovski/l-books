Given /the following books exist/ do |books_table|
  books_table.hashes.each do |book|
    Book.create!(book)
  end
end

Given /the following users exist/ do |users_table|
  users_table.hashes.each do |user|
    User.create!(user)
  end
end

Given /the following courses exist/ do |courses_table|
  courses_table.hashes.each do |course|
    Course.create!(course)
  end
end

Given /the following book-course associations exist/ do |bca_table|
  bca_table.hashes.each do |bca|
    BookCourseAssociation.create!(bca)
  end
end

Given /the following listings exist/ do |listings_table|
  listings_table.hashes.each do |listing|
    Listing.create!(listing)
  end
end
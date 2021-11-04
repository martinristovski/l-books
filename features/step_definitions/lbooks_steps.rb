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


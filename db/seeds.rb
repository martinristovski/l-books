# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# users
u1 = User.create!(
  first_name: "Vishnu",
  last_name: "Nair",
  uni: "vn1234",
  email: "vn@columbia.edu",
  school: "SEAS",
  password: "password123",
  password_confirmation: "password123"
)
u2 = User.create!(
  first_name: "Ivy",
  last_name: "Cao",
  uni: "ic1234",
  email: "ic@columbia.edu",
  school: "SEAS",
  password: "password456",
  password_confirmation: "password456"
)
u3 = User.create!(
  first_name: "Aditya",
  last_name: "Satnalika",
  uni: "as1234",
  email: "as@columbia.edu",
  school: "SEAS",
  password: "pass123",
  password_confirmation: "pass123"
)
u4 = User.create!(
  first_name: "Martin",
  last_name: "Ristovski",
  uni: "mr1234",
  email: "mr@columbia.edu",
  school: "CC",
  password: "pass456",
  password_confirmation: "pass456"
)

# books
b1 = Book.create!(
  title: "The Iliad of Homer",
  authors: "Richmond Lattimore; Homer",
  edition: nil,
  publisher: "University of Chicago Press",
  isbn: "9780226470498",
  image_url: "https://images-na.ssl-images-amazon.com/images/I/61xbfNmcFwL.jpg" # TODO: S3 later.
)
b2 = Book.create!(
  title: "Plato Symposium (Hackett Classics)",
  authors: "Plato; Alexander Nehamas; Paul Woodruff",
  edition: "1989 Edition",
  publisher: "Hackett Publishing Co",
  isbn: "9780872200760",
  image_url: "https://images-na.ssl-images-amazon.com/images/I/41vx+Jrc8GL.jpg" # TODO: S3 later.
)
b3 = Book.create!(
  title: "The Aeneid of Virgil (Bantam Classics)",
  authors: "Virgil; Allen Mandelbaum",
  edition: "Revised ed.",
  publisher: "Bantam Classics",
  isbn: "9780553210415",
  image_url: "https://images-na.ssl-images-amazon.com/images/I/71Rd1htsJvL.jpg" # TODO: S3 later.
)

# courses
c1 = Course.create!(
  code: "HUMA1001",
  name: "Masterpieces of Western Literature and Philosophy I"
)
c2 = Course.create!(
  code: "HUMA1002",
  name: "Masterpieces of Western Literature and Philosophy II"
)

# book-course associations
bca1 = BookCourseAssociation.create!(
  book_id: b1.id,
  course_id: c1.id
)
bca2 = BookCourseAssociation.create!(
  book_id: b2.id,
  course_id: c1.id
)
bca3 = BookCourseAssociation.create!(
  book_id: b3.id,
  course_id: c1.id
)

# listings
l1 = Listing.create!(
  book_id: b1.id,
  price: 5.00,
  condition: "Like new",
  description: "Copy of the Iliad. Looks like it was never used (which may or may not have been the case)...",
  seller_id: u1.id
)
l2 = Listing.create!(
  book_id: b1.id,
  price: 4.50,
  condition: "Used, slightly worn",
  description: "Another copy of the Iliad. This actually looks like it was used.",
  seller_id: u2.id
)
l3 = Listing.create!(
  book_id: b2.id,
  price: 5.15,
  condition: "Used",
  description: "Plato's Symposium. Used.",
  seller_id: u3.id
)

# listing images
l1_i1 = ListingImage.create!(
  listing_id: l1.id,
  image_url: "https://images-na.ssl-images-amazon.com/images/I/61xbfNmcFwL.jpg" # TODO: Using stock image for now.
)
l1_i2 = ListingImage.create!(  # duplicate image to test multiple in UI
  listing_id: l1.id,
  image_url: "https://images-na.ssl-images-amazon.com/images/I/61xbfNmcFwL.jpg" # TODO: Using stock image for now.
)
l2_i1 = ListingImage.create!(
  listing_id: l2.id,
  image_url: "https://images-na.ssl-images-amazon.com/images/I/61xbfNmcFwL.jpg" # TODO: Using stock image for now.
)
l3_i1 = ListingImage.create!(
  listing_id: l3.id,
  image_url: "https://images-na.ssl-images-amazon.com/images/I/41vx+Jrc8GL.jpg" # TODO: Using stock image for now.
)

# listing bookmarks
# lb1 = ListingBookmark.create!(
#   listing_id: l3.id,
#   user_id: u4.id
# )
# lb2 = ListingBookmark.create!(
#   listing_id: l2.id,
#   user_id: u4.id
# )

# listing contacts (only record when contact initiated)
lc1 = ListingContact.create!(
  listing_id: l2.id,
  contact_timestamp: DateTime.new(2021, 10, 24, 9, 27, 29),
  initiator_id: u4.id,
  message: nil
)

# user reputation ratings
ur1 = UserReputationRating.create!(
  target_user_id: u3.id,
  rater_user_id: u2.id,
  listing_id: l2.id,
  score: 5
)

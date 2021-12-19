Feature: View listing information

  As users of L'Books
  So that we can buy and sell books
  We want to look at listing information

Background: books, users, courses, BCAs, and listings have been added to the database

  Given the following books exist:
    | id | title          | authors           | edition | isbn          | image_id |
    |  1 | Sample Book 1  | Sample Example    | 2       | 9781123456213 | id_1     |
    |  2 | Sample Book 2  | Sample Example II | 4       | 9781575675320 | id_2     |
    |  3 | Sample Book 3  | Sample Example III| 6       | 9781230914832 | id_3     |

  Given the following users exist:
    | id | last_name | first_name | email              | school | password     | password_confirmation |
    |  1 | Doe       | Jane       | jd123@columbia.edu | SEAS   | qwerty123456 | qwerty123456          |
    |  2 | Doe       | John       | jd456@columbia.edu | CC     | qwerty135790 | qwerty135790          |
    |  3 | Doe       | Janet      | jd789@columbia.edu | GS     | qwerty246810 | qwerty246810          |

  Given the following courses exist:
    | id | code       | name              |
    |  1 | COMSW4995  | Engineering ESaaS |
    |  2 | COMSW9999  | Example Course    |

  Given the following book-course associations exist:
    | book_id | course_id |
    | 1       | 1         |
    | 2       | 2         |
    | 3       | 1         |

  Given the following listings exist:
    | id | book_id   | price   | condition | description     | seller_id | status    | buyer_id | bought_at_price |
    |  1 | 2         | 4.95    | Like new  | This is a test. | 1         | published |          |                 |
    |  2 | 1         | 5.00    | Like new  | This is a test. | 1         | sold      | 2        | 5.00            |
    |  3 | 3         | 6.00    | Like new  | This is a test. | 2         | published |          |                 |

  Scenario: Perform a standard search and pull up a book and then a listing via search
    Given I am on the home page
    And I select "ISBN" from "criteria"
    And I fill in "search" with "9781575675320"
    And I press "Go"
    Then I should be on the search results page

    Then I click on the element with ID "result-0"
    And I should see "Sample Book 2"
    And I should see "1 listing found:"

    Then I click on the element with ID "result-0"
    And I should see "Seller Information"
    And I should see "Name: **Hidden**"

  Scenario: Perform search on a course that does not yet exist in our database
    Given I am on the home page
    And I select "Course Number" from "criteria"
    And I fill in "search" with "DSHE4118"
    Then I should not find the element with ID "result-0"

  Scenario: Pull up listing information for a non-existent listing
    Given I am on the listing view page for a listing with ID "4"
    Then  I should be on the home page
    And   I should see "Sorry, we couldn't find a listing with that ID."

  Scenario: Mark non-existent listing as sold
    Given I am on the sold view page for a listing with ID "6"
    Then I should be on the home page
    And I should see "Sorry, we couldn't find a listing with that ID."

  Scenario: Edit listing information while not logged in
    Given I am on the home page
    And I am on the listing edit page for a listing with ID "1"
    Then I should be on the signin page

  Scenario: Create new listing while not logged in
    Given I am on the home page
    And I am on the listing creation page
    Then I should be on the signin page

  Scenario: Edit listing information for a non-existent listing while logged in
    Given I am on the home page
    And I follow "Sign In"
    And I fill in "email" with "jd123@columbia.edu"
    And I fill in "password" with "qwerty123456"
    And I press "Log In"
    Then I should be on the logged in page
    And I should see "Logged in successfully"

    And I am on the listing edit page for a listing with ID "4"
    Then I should be on the home page
    And I should see "Sorry, we couldn't find a listing with that ID."

  Scenario: Log in to user account with non-existent email and password
    Given I am on the home page
    And I follow "Sign In"
    And I fill in "email" with "test1234@gmail.com"
    And I fill in "password" with "test1234"
    And I press "Log In" 
    Then I should be on the signin page
    And I should see "Invalid email or password"

Scenario: Log in to user account with incorrect password for existing account
    Given I am on the home page
    And I follow "Sign In"
    And I fill in "email" with "jd123@columbia.edu"
    And I fill in "password" with "test1234"
    And I press "Log In"
    Then I should be on the signin page
    And I should see "Invalid email or password"

Scenario: Log in and log out of user account with valid credentials
    Given I am on the home page
    And I follow "Sign In"
    And I fill in "email" with "jd123@columbia.edu"
    And I fill in "password" with "qwerty123456"
    And I press "Log In"
    Then I should be on the logged in page
    And I should see "Logged in successfully"

    And I follow "Sign Out"
    Then I should see "Logged Out"

Scenario: Create a new user account failed
    Given I am on the home page
    And I follow "Register"
    Then I should be on the signup page
    When I fill in "user_email" with "test1234@gmail.com"
    And I press "Sign Up"
    Then I should be on the signup page
    And I should not see "Successfully created account"

Scenario: Create a new listing without any initial fields completed
    Given I am on the home page
    And I follow "Sign In"
    And I fill in "email" with "jd123@columbia.edu"
    And I fill in "password" with "qwerty123456"
    And I press "Log In"
    Then I should be on the logged in page
    And I should see "Logged in successfully"

    Then I follow "New Listing"
    And I press "Post"

    Then I should see "We encountered the following errors"
    And I should see "The ISBN is required."
    And I should see "Please enter the book's price."
    And I should see "Please enter the book's condition."
    And I should see "Please enter a description for the book."
    And I should see "Invalid course code. Please use correct input form (E.g. 'HUMA1001')."
    And I should see "You must upload at least one image."

Scenario: Create a new listing without any additional fields completed and not in GBooks API
    Given I am on the home page
    And I follow "Sign In"
    And I fill in "email" with "jd123@columbia.edu"
    And I fill in "password" with "qwerty123456"
    And I press "Log In"
    Then I should be on the logged in page
    And I should see "Logged in successfully"

    Then I follow "New Listing"
    And I fill in "ISBN" with "1000000000000"
    And I fill in "Condition" with "good"
    And I fill in "Price" with "15"
    And I fill in "Course" with "COMSW4995"
    And I fill in "Description" with "This is a test listing."
    When I attach the file "../l-books/db/seed_files/b1_iliad.jpg" to "image"
    And I press "Upload"
    Then I should see "Image uploaded."
    And I press "Post"

    Then I should see "Please enter more information about this book."

    Then I fill in "Title" with ""
    And I fill in "Author(s)" with ""
    And I fill in "Publisher" with ""
    And I press "Post"

    Then I should see "We encountered the following errors"
    And I should see "Please enter the unknown book's title."
    And I should see "Please enter the unknown book's author list."
    And I should see "Please enter the unknown book's publisher."

Scenario: Create a new listing with price and ISBN fields invalid
    Given I am on the home page
    And I follow "Sign In"
    And I fill in "email" with "jd123@columbia.edu"
    And I fill in "password" with "qwerty123456"
    And I press "Log In"
    Then I should be on the logged in page
    And I should see "Logged in successfully"

    Then I follow "New Listing"
    And I fill in "ISBN" with "12345678910"
    And I fill in "Condition" with "good"
    And I fill in "Price" with "$15"
    And I fill in "Course" with "SaaS"
    And I fill in "Description" with "This is a test listing."
    And I press "Post"

    Then I should see "The ISBN you have entered is invalid."
    And I should see "The price you have entered is invalid."

Scenario: Create a new listing with extra fields auto-completed via GBooks API
    Given I am on the home page
    And I follow "Sign In"
    And I fill in "email" with "jd123@columbia.edu"
    And I fill in "password" with "qwerty123456"
    And I press "Log In"
    Then I should be on the logged in page
    And I should see "Logged in successfully"

    Then I follow "New Listing"
    And I fill in "ISBN" with "9780201563177"
    And I fill in "Condition" with "good"
    And I fill in "Price" with "15"
    And I fill in "Course" with "COMSW4118"
    And I fill in "Description" with "This is a test listing."
    When I attach the file "../l-books/db/seed_files/b1_iliad.jpg" to "image"
    And I press "Upload"
    Then I should see "Image uploaded."

    And I press "X"
    Then I should see "Image deleted. You have 5 slot(s) left."

    When I attach the file "../l-books/db/seed_files/b1_iliad.jpg" to "image"
    And I press "Upload"
    Then I should see "Image uploaded."
    And I press "Post"

    Then I should see "Listing created!"

Scenario: Create a new listing via autocomplete by GBooks API but attempting to exceed max number of images
    Given I am on the home page
    And I follow "Sign In"
    And I fill in "email" with "jd123@columbia.edu"
    And I fill in "password" with "qwerty123456"
    And I press "Log In"
    Then I should be on the logged in page
    And I should see "Logged in successfully"

    Then I follow "New Listing"
    And I fill in "ISBN" with "9780201563177"
    And I fill in "Condition" with "good"
    And I fill in "Price" with "15"
    And I fill in "Course" with "COMSW4118"
    And I fill in "Description" with "This is a test listing."
    
    When I attach the file "../l-books/db/seed_files/b1_iliad.jpg" to "image"
    And I press "Upload"
    Then I should see "Image uploaded. You have 4 slot(s) left."

    When I press "X"
    Then I should see "Image deleted. You have 5 slot(s) left."

    When I attach the file "../l-books/db/seed_files/b1_iliad.jpg" to "image"
    And I press "Upload"
    Then I should see "Image uploaded. You have 4 slot(s) left."

    When I attach the file "../l-books/db/seed_files/b1_iliad.jpg" to "image"
    And I press "Upload"
    Then I should see "Image uploaded. You have 3 slot(s) left."

    When I attach the file "../l-books/db/seed_files/b1_iliad.jpg" to "image"
    And I press "Upload"
    Then I should see "Image uploaded. You have 2 slot(s) left."

    When I attach the file "../l-books/db/seed_files/b1_iliad.jpg" to "image"
    And I press "Upload"
    Then I should see "Image uploaded. You have 1 slot(s) left."

    When I attach the file "../l-books/db/seed_files/b1_iliad.jpg" to "image"
    And I press "Upload"
    Then I should see "Image uploaded. You have no more slots left."
    
    When I attach the file "../l-books/db/seed_files/b1_iliad.jpg" to "image"
    And I press "Upload"
    Then I should see "You have already uploaded the maximum of 5 images."

Scenario: Create a new listing with all fields manually completed
    Given I am on the home page
    And I follow "Sign In"
    And I fill in "email" with "jd123@columbia.edu"
    And I fill in "password" with "qwerty123456"
    And I press "Log In"
    Then I should be on the logged in page
    And I should see "Logged in successfully"

    Then I follow "New Listing"
    And I fill in "ISBN" with "1234567891015"
    And I fill in "Condition" with "good"
    And I fill in "Price" with "15"
    And I fill in "Course" with "COMSW4995"
    And I fill in "Description" with "This is a test listing."
    When I attach the file "../l-books/db/seed_files/b1_iliad.jpg" to "image"
    And I press "Upload"
    Then I should see "Image uploaded."    
    And I press "Post"
    
    Then I should see "Please enter more information about this book."
    
    Then I fill in "Title" with "Test Listing"
    And I fill in "Author(s)" with "author test"
    And I fill in "Edition" with "1"
    And I fill in "Publisher" with "McGraw Hill"
    And I press "Post"

    Then I should see "Listing created!"

    And I follow "L'Books"
    And I select "ISBN" from "criteria"
    And I fill in "search" with "1234567891015"
    And I press "Go"
    Then I should see "Test Listing"

    And I follow "Sign Out"
    Then I should see "Logged Out"

Scenario: Create a new listing for an existing ISBN in our app database
    Given I am on the home page
    And I follow "Sign In"
    And I fill in "email" with "jd123@columbia.edu"
    And I fill in "password" with "qwerty123456"
    And I press "Log In"
    Then I should be on the logged in page
    And I should see "Logged in successfully"

    Then I follow "New Listing"
    And I fill in "ISBN" with "9781575675320"
    And I fill in "Condition" with "good"
    And I fill in "Price" with "15"
    And I fill in "Course" with "COMSW4995"
    And I fill in "Description" with "This is a test listing."
    
    When I attach the file "../l-books/db/seed_files/extra_large_image.jpg" to "image"
    And I press "Upload"
    Then I should see "The image you attempted to upload is too big. Max allowed size: 2 MB. Your image: 5.15 MB"

    When I attach the file "../l-books/db/seed_files/b1_iliad.jpg" to "image"
    And I press "Upload"
    Then I should see "Image uploaded."  
    And I press "Post"
    
    Then I should see "Listing created!"

Scenario: Contact a seller via a listing
    Given I am on the home page
    And I follow "Sign In"
    And I fill in "email" with "jd456@columbia.edu"
    And I fill in "password" with "qwerty135790"
    And I press "Log In"
    Then I should be on the logged in page
    And I should see "Logged in successfully"    

    And I select "ISBN" from "criteria"
    And I fill in "search" with "9781575675320"
    And I press "Go"
    Then I should be on the search results page

    Then I click on the element with ID "result-0"
    And I should see "Sample Book 2"
    And I should see "1 listing found:"

    Then I click on the element with ID "result-0"
    And I should see "Seller Information"
    And I should see "Name: Jane Doe" 
    And I should see "School: SEAS"
    And I should see "Reputation: No ratings received."
    And I should see "Email: jd123@columbia.edu"

    And I should see "Contact Seller"

Scenario: Edit a user's existing listing
    Given I am on the home page
    And I follow "Sign In"
    And I fill in "email" with "jd123@columbia.edu"
    And I fill in "password" with "qwerty123456"
    And I press "Log In"
    Then I should be on the logged in page
    And I should see "Logged in successfully"

    Then I follow "New Listing"
    And I fill in "ISBN" with "1234567891111"
    And I fill in "Condition" with "good"
    And I fill in "Price" with "15"
    And I fill in "Course" with "COMSW4995"
    And I fill in "Description" with "This is a test listing."
    When I attach the file "../l-books/db/seed_files/b1_iliad.jpg" to "image"
    And I press "Upload"
    Then I should see "Image uploaded."    
    And I press "Post"

    Then I should see "Please enter more information about this book."

    Then I fill in "Title" with "Sample Book 3"
    And I fill in "Author(s)" with "author test"
    And I fill in "Edition" with "1"
    And I fill in "Publisher" with "McGraw Hill"
    And I press "Post"

    Then I should see "Listing created!"

    And I follow "L'Books"
    And I select "ISBN" from "criteria"
    And I fill in "search" with "1234567891111"
    And I press "Go"
    Then I should be on the search results page

    Then I click on the element with ID "result-0"
    And I should see "Sample Book 3"
    And I should see "1 listing found:"

    Then I click on the element with ID "result-0"
    And I should see "Seller Information"
    And I should see "Name: Jane Doe"

    And I follow "Edit"

    And I fill in "condition" with "fair"
    And I fill in "course" with "COMSW4995"    
    And I press "X"
    And I press "Save"
    Then I should see "You must upload at least one image."

    And I press "Upload"
    Then I should see "You must upload at least one image."
    When I attach the file "../l-books/db/seed_files/extra_large_image.jpg" to "image"
    And I press "Upload"
    Then I should see "The image you attempted to upload is too big. Max allowed size: 2 MB. Your image: 5.15 MB"

    When I attach the file "../l-books/db/seed_files/b1_iliad.jpg" to "image"
    And I press "Upload"
    Then I should see "Image uploaded. You have 4 slot(s) left."

    When I press "X"
    Then I should see "Image deleted. You have 5 slot(s) left."

    When I attach the file "../l-books/db/seed_files/b1_iliad.jpg" to "image"
    And I press "Upload"
    Then I should see "Image uploaded. You have 4 slot(s) left."

    When I attach the file "../l-books/db/seed_files/b1_iliad.jpg" to "image"
    And I press "Upload"
    Then I should see "Image uploaded. You have 3 slot(s) left."

    When I attach the file "../l-books/db/seed_files/b1_iliad.jpg" to "image"
    And I press "Upload"
    Then I should see "Image uploaded. You have 2 slot(s) left."

    When I attach the file "../l-books/db/seed_files/b1_iliad.jpg" to "image"
    And I press "Upload"
    Then I should see "Image uploaded. You have 1 slot(s) left."

    When I attach the file "../l-books/db/seed_files/b1_iliad.jpg" to "image"
    And I press "Upload"
    Then I should see "Image uploaded. You have no more slots left."

    When I attach the file "../l-books/db/seed_files/b1_iliad.jpg" to "image"
    And I press "Upload"
    Then I should see "You have already uploaded the maximum of 5 images."
    And I press "Save"

    Then I should see "Listing updated!"
    And I should see "fair"
    And I should not see "good"

Scenario: Mark a user's existing listing as sold to a non-existent user
    Given I am on the home page
    And I follow "Sign In"
    And I fill in "email" with "jd123@columbia.edu"
    And I fill in "password" with "qwerty123456"
    And I press "Log In"
    Then I should be on the logged in page
    And I should see "Logged in successfully"

    Then I follow "New Listing"
    And I fill in "ISBN" with "1234567891111"
    And I fill in "Condition" with "good"
    And I fill in "Price" with "15"
    And I fill in "Course" with "COMSW4995"
    And I fill in "Description" with "This is a test listing."
    When I attach the file "../l-books/db/seed_files/b1_iliad.jpg" to "image"
    And I press "Upload"
    Then I should see "Image uploaded."
    And I press "Post"

    Then I should see "Please enter more information about this book."

    Then I fill in "Title" with "Sample Book 3"
    And I fill in "Author(s)" with "author test"
    And I fill in "Edition" with "1"
    And I fill in "Publisher" with "McGraw Hill"
    And I press "Post"

    Then I should see "Listing created!"

    And I follow "L'Books"
    And I select "ISBN" from "criteria"
    And I fill in "search" with "1234567891111"
    And I press "Go"
    Then I should be on the search results page

    Then I click on the element with ID "result-0"
    And I should see "Sample Book 3"
    And I should see "1 listing found:"

    Then I click on the element with ID "result-0"
    And I should see "Seller Information"
    And I should see "Name: Jane Doe"

    And I follow "Mark As Sold"

    Then I should see "Record the Purchase"
    And I fill in "user_email" with "test@gmail.com"
    And I fill in "amount" with "15"
    And I press "Submit"

    Then I should see "Please enter a valid email"

Scenario: Mark a user's existing listing as sold to an existing user
    Given I am on the home page
    And I follow "Sign In"
    And I fill in "email" with "jd123@columbia.edu"
    And I fill in "password" with "qwerty123456"
    And I press "Log In"
    Then I should be on the logged in page
    And I should see "Logged in successfully"

    Then I follow "New Listing"
    And I fill in "ISBN" with "1234567891111"
    And I fill in "Condition" with "good"
    And I fill in "Price" with "15"
    And I fill in "Course" with "COMSW4995"
    And I fill in "Description" with "This is a test listing."
    When I attach the file "../l-books/db/seed_files/b1_iliad.jpg" to "image"
    And I press "Upload"
    Then I should see "Image uploaded."
    And I press "Post"

    Then I should see "Please enter more information about this book."

    Then I fill in "Title" with "Sample Book 3"
    And I fill in "Author(s)" with "author test"
    And I fill in "Edition" with "1"
    And I fill in "Publisher" with "McGraw Hill"
    And I press "Post"

    Then I should see "Listing created!"

    And I follow "L'Books"
    And I select "ISBN" from "criteria"
    And I fill in "search" with "1234567891111"
    And I press "Go"
    Then I should be on the search results page

    Then I click on the element with ID "result-0"
    And I should see "Sample Book 3"
    And I should see "1 listing found:"

    Then I click on the element with ID "result-0"
    And I should see "Seller Information"
    And I should see "Name: Jane Doe"

    And I follow "Mark As Sold"

    Then I should see "Record the Purchase"
    And I fill in "user_email" with "jd456@columbia.edu"
    And I fill in "amount" with "15"
    And I press "Submit"

    Then I should see "This listing has been marked as SOLD!"
    And I follow "L'Books"
    And I select "ISBN" from "criteria"
    And I fill in "search" with "1234567891111"
    And I press "Go"
    Then I should be on the search results page

    Then I click on the element with ID "result-0"
    And I should see "Sample Book 3"
    And I should see "No listings found!"
    And I should see "1 sold listing found"

    And I follow "Sign Out"
    Then I should see "Logged Out"
   
Scenario: Rate a transaction when signed out
    Given I am on the home page
    And I am on the rate selection page for a listing with ID "2"
    Then I should be on the signin page
 
Scenario: Rate a transaction
    Given I am on the home page
    And I follow "Sign In"
    And I fill in "email" with "jd456@columbia.edu"
    And I fill in "password" with "qwerty135790"    
    And I press "Log In"
    And I should see "Logged in successfully"

    And I follow "Dashboard"
    Then I should see "Listings Purchased (1)"

    And I follow "Rate"
    And I choose "rating_5"
    And I press "Submit"
    Then I should see "Edit Rating (gave 5/5)"

    And I follow "Edit Rating (gave 5/5)"
    Then I should see "You have already entered a rating for this transaction. If you re-submit this form, you will edit your previous rating."
    And I choose "rating_4"
    And I press "Submit"
    Then I should see "Edit Rating (gave 4/5)"
    And I should not see "Edit Rating (gave 5/5)"

Scenario: Attempts to rate a non-existent listing
    Given I am on the home page
    And I follow "Sign In"
    And I fill in "email" with "jd456@columbia.edu"
    And I fill in "password" with "qwerty135790"
    And I press "Log In"
    And I should see "Logged in successfully"
    
    When I am on the rate selection page for a listing with ID "6"
    Then I should be on the home page
    And I should see "Could not find the listing you are looking for."

Scenario: Attempts to rate a listing that was not bought by themselves
    Given I am on the home page
    And I follow "Sign In"
    And I fill in "email" with "jd789@columbia.edu"
    And I fill in "password" with "qwerty246810"
    And I press "Log In"
    And I should see "Logged in successfully"
   
    When I am on the rate selection page for a listing with ID "2"
    Then I should be on the home page
    And I should see "You cannot rate this transaction."

Scenario: Delete a user's existing listing
    Given I am on the home page
    And I follow "Sign In"
    And I fill in "email" with "jd123@columbia.edu"
    And I fill in "password" with "qwerty123456"
    And I press "Log In"
    Then I should be on the logged in page
    And I should see "Logged in successfully"

    Then I follow "New Listing"
    And I fill in "ISBN" with "1234567891111"
    And I fill in "Condition" with "good"
    And I fill in "Price" with "1"
    And I fill in "Course" with "COMSW4995"
    And I fill in "Description" with "This is a test listing."
    When I attach the file "../l-books/db/seed_files/b1_iliad.jpg" to "image"
    And I press "Upload"
    Then I should see "Image uploaded."    
    And I press "Post"
    Then I should see "Please enter more information about this book."
    Then I fill in "Title" with "Sample Book 3"
    And I fill in "Author(s)" with "author test"
    And I fill in "Edition" with "1"
    And I fill in "Publisher" with "McGraw Hill"
    And I press "Post"
    Then I should see "Listing created!"

    And I follow "L'Books"
    And I select "ISBN" from "criteria"
    And I fill in "search" with "1234567891111"
    And I press "Go"
    Then I should be on the search results page

    Then I click on the element with ID "result-0"
    And I should see "Sample Book 3"
    And I should see "1 listing found:"

    Then I click on the element with ID "result-0"
    And I should see "Seller Information"
    And I should see "Name: Jane Doe"

    And I follow "Delete"
    And I press "Go Back"
    Then I should see "Seller Information"
    And I should see "Name: Jane Doe"

    And I follow "Delete"
    And I press "Delete!"
    Then I should be on the home page
    And I should see "Listing deleted!"

    And I select "ISBN" from "criteria"
    And I fill in "search" with "1234567891111"
    And I press "Go"
    Then I should be on the search results page
    
    Then I click on the element with ID "result-0"
    And I should see "Sample Book 3"
    And I should see "No listings found!"

Scenario: Attempt to edit a listing that is not owned by current user
    Given I am on the home page
    And I follow "Sign In"
    And I fill in "email" with "jd456@columbia.edu"
    And I fill in "password" with "qwerty135790"
    And I press "Log In"
    Then I should be on the logged in page
    And I should see "Logged in successfully"

    When I am on the listing edit page for a listing with ID "1"
    Then I should see "Forbidden: Only the seller of a listing can edit that listing."

Scenario: Attempt to delete a listing that is not owned by current user
    Given I am on the home page
    And I follow "Sign In"
    And I fill in "email" with "jd456@columbia.edu"
    And I fill in "password" with "qwerty135790"
    And I press "Log In"
    Then I should be on the logged in page
    And I should see "Logged in successfully"

    When I am on the listing deletion page for a listing with ID "1"
    Then I should see "Forbidden: Only the seller of a listing can delete that listing."

Scenario: Attempt to take privileged actions while not logged in
    Given I am on the listing deletion page for a listing with ID "4"
    Then  I should be on the signin page

Scenario: Attempt to delete a non-existent listing
    Given I am on the home page
    And I follow "Sign In"
    And I fill in "email" with "jd456@columbia.edu"
    And I fill in "password" with "qwerty135790"
    And I press "Log In"
    Then I should be on the logged in page
    And I should see "Logged in successfully"

    When I am on the listing deletion page for a listing with ID "4"
    Then I should see "Sorry, we couldn't find a listing with that ID."

Scenario: Bookmark a listing
    Given I am on the home page
    And I follow "Sign In"
    And I fill in "email" with "jd456@columbia.edu"
    And I fill in "password" with "qwerty135790"
    And I press "Log In"
    Then I should be on the logged in page
    And I should see "Logged in successfully"

    And I select "ISBN" from "criteria"
    And I fill in "search" with "9781575675320"
    And I press "Go"
    Then I should be on the search results page

    Then I click on the element with ID "result-0"
    And I should see "Sample Book 2"
    And I should see "1 listing found:"

    Then I click on the element with ID "result-0"
    And I should see "Seller Information"
    And I should see "Name: Jane Doe"
    And I should see "School: SEAS"
    And I should see "Reputation: No ratings received."
    And I should see "Email: jd123@columbia.edu"

    And I follow "Save"
    Then I should see "Listing bookmarked!"
    And I follow "Unsave"
    Then I should see "Bookmark removed!"

Scenario: Attempts to bookmark own listing
    Given I am on the home page
    And I follow "Sign In"
    And I fill in "email" with "jd456@columbia.edu"
    And I fill in "password" with "qwerty135790"
    And I press "Log In"
    Then I should be on the logged in page
    And I should see "Logged in successfully"

    When I am on the bookmark page for a listing with ID "3"
    Then I should see "Cannot bookmark your own listing."

Scenario: Attempts to bookmark non-existent listing
    Given I am on the home page
    And I follow "Sign In"
    And I fill in "email" with "jd456@columbia.edu"
    And I fill in "password" with "qwerty135790"
    And I press "Log In"
    Then I should be on the logged in page
    And I should see "Logged in successfully"

    When I am on the bookmark page for a listing with ID "6"
    Then I should see "Sorry, we couldn't find a listing with that ID."

Scenario: Attempts to bookmark when not signed in
    Given I am on the home page
    When I am on the bookmark page for a listing with ID "1"
    Then I should be on the signin page

Scenario: Attempts to visit dashboard when not signed in
    Given I am on the home page
    When I am on the dashboard page
    Then I should be on the signin page

Scenario: Attempts to logout when not signed in
    Given I am on the home page
    When I am on the logged out page
    Then I should be on the home page
    And I should see "Cannot log out if you never logged in."

Scenario: Attempts to logout directly with URL when signed in
    Given I am on the home page
    And I follow "Sign In"
    And I fill in "email" with "jd456@columbia.edu"
    And I fill in "password" with "qwerty135790"
    And I press "Log In"
    Then I should be on the logged in page
    And I should see "Logged in successfully"
    
    And I am on the logged out page
    Then I should see "Logged Out"

Scenario: Attempts to sign in when already signed in
    Given I am on the home page
    And I follow "Sign In"
    And I fill in "email" with "jd456@columbia.edu"
    And I fill in "password" with "qwerty135790"
    And I press "Log In"
    Then I should be on the logged in page
    And I should see "Logged in successfully"

    And I am on the signin page
    And I fill in "email" with "jd456@columbia.edu"
    And I fill in "password" with "qwerty135790"
    And I press "Log In"
    Then I should be on the logged in page
    And I should see "Logged in successfully"


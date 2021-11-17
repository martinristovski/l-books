Feature: View listing information

  As users of L'Books
  So that we can buy and sell books
  We want to look at listing information

Background: books, users, courses, BCAs, and listings have been added to the database

  Given the following books exist:
    | id | title          | authors           | edition | isbn          |
    |  1 | Sample Book 1  | Sample Example    | 2       | 9781123456213 |
    |  2 | Sample Book 2  | Sample Example II | 4       | 9781575675320 |

  Given the following users exist:
    | id | last_name | first_name | email              | school | password     | password_confirmation |
    |  1 | Doe       | Jane       | jd123@columbia.edu | SEAS   | qwerty123456 | qwerty123456          |
    |  2 | Doe       | John       | jd456@columbia.edu | CC     | qwerty135790 | qwerty135790          |

  Given the following courses exist:
    | id | code       | name              |
    |  1 | COMS W4995 | Engineering ESaaS |
    |  2 | COMS W9999 | Example Course    |

  Given the following book-course associations exist:
    | book_id | course_id |
    | 1       | 1         |
    | 2       | 2         |

  Given the following listings exist:
    | id | book_id   | price   | condition | description     | seller_id |
    |  1 | 2         | 4.95    | Like new  | This is a test. | 1         |

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

  Scenario: Pull up listing information for a non-existent listing
    Given I am on the listing view page for a listing with ID "4"
    Then  I should be on the home page
    And   I should see "Sorry, we couldn't find a listing with that ID."

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

Scenario: Create a new user account successfully
    Given I am on the home page
    And I follow "Register"
    Then I should be on the signup page

    When I fill in "user_email" with "test1234@gmail.com"
    And I fill in "user_first_name" with "test"
    And I fill in "user_last_name" with "user"
    And I fill in "user_uni" with "test1234"
    And I fill in "user_school" with "SEAS"
    And I fill in "user_password" with "password1000"
    And I fill in "user_password_confirmation" with "password1000"
    And I press "Sign Up"
    Then I should be on the logged in page
    And I should see "Successfully created account"

    And I follow "Sign Out"
    Then I should see "Logged Out"

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

Scenario: Create a new listing without any additional fields completed
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
    And I fill in "Course" with "SaaS"
    And I fill in "Description" with "This is a test listing."
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

Scenario: Create a new listing with all fields completed
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
    And I fill in "Course" with "SaaS"
    And I fill in "Description" with "This is a test listing."
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

Scenario: Create a new listing for an existing ISBN
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
    And I fill in "Course" with "SaaS"
    And I fill in "Description" with "This is a test listing."
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
    And I should see "Reputation: 4.5"
    And I should see "Email: jd123@columbia.edu"

    Then I fill in "post" with "Hi! I would like to purchase this listing"
    Then I follow "Send"

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
    And I fill in "Course" with "SaaS"
    And I fill in "Description" with "This is a test listing."
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
    And I press "Save"

    Then I should see "fair"
    And I should not see "good"

Scenario: Edit a user's existing listing with errors
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
    And I fill in "Course" with "SaaS"
    And I fill in "Description" with "This is a test listing."
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

    And I fill in "condition" with ""
    And I fill in "price" with ""
    And I fill in "description" with ""
    And I press "Save"

    Then I should see "We encountered the following errors"
    And I should see "Please enter the book's condition."
    And I should see "Please enter the book's price."
    And I should see "Please enter a description for the book."

    And I fill in "condition" with "ok"
    And I fill in "price" with "$13"
    And I fill in "description" with "test"
    And I press "Save"

    Then I should see "We encountered the following errors"
    And I should see "The price you have entered is invalid"

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
    And I fill in "Course" with "SaaS"
    And I fill in "Description" with "This is a test listing."
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

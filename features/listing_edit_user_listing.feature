Feature: View listing information

  As users of L'Books
  So that we can buy and sell books
  We want to look at listing information

  Background: books, users, courses, BCAs, and listings have been added to the database

    Given the following books exist:
      | id | title          | authors           | edition | isbn          | image_id |
      |  1 | Sample Book 1  | Sample Example    | 2       | 9781123456213 | id_1     |
      |  2 | Sample Book 2  | Sample Example II | 4       | 9781575675320 | id_2     |

    Given the following users exist:
      | id | last_name | first_name | email              | school | password     | password_confirmation |
      |  1 | Doe       | Jane       | jd123@columbia.edu | SEAS   | qwerty123456 | qwerty123456          |
      |  2 | Doe       | John       | jd456@columbia.edu | CC     | qwerty135790 | qwerty135790          |

    Given the following courses exist:
      | id | code      |
      |  1 | COMSW4995 |
      |  2 | COMSW9999 |

    Given the following book-course associations exist:
      | book_id | course_id |
      | 1       | 1         |
      | 2       | 2         |

    Given the following listings exist:
      | id | book_id   | price   | condition | description     | seller_id | status    |
      |  1 | 2         | 4.95    | Like new  | This is a test. | 1         | published |

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

    And I fill in "condition" with ""
    And I fill in "price" with ""
    And I fill in "description" with ""
    And I fill in "course" with ""
    And I press "Save"

    Then I should see "We encountered the following errors"
    And I should see "Please enter the book's condition."
    And I should see "Please enter the book's price."
    And I should see "Invalid course code. Please use correct input form (E.g. 'HUMA1001')."
    And I should see "Please enter a description for the book."

    And I fill in "condition" with "ok"
    And I fill in "price" with "$13"
    And I fill in "course" with "COMSW4995"
    And I fill in "description" with "test"
    When I attach the file "../l-books/db/seed_files/b1_iliad.jpg" to "image"
    And I press "Upload"
    Then I should see "Image uploaded."
    And I press "Save"

    Then I should see "We encountered the following errors"
    And I should see "The price you have entered is invalid"

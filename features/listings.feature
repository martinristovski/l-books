Feature: CRUD listings

  As users of L'Books
  So that we can buy and sell books
  We want to create, retrieve, update, and delete listings

Background: books, users, and listings have been added to the database

    Given the following books exist:
      | id | title          | author         | edition | isbn             |
      |  1 | Sample Book 1  | Sample Example | 2       | 978-1-1234562-13 |

    Given the following users exist:
      | id | last_name | first_name | email              | school
      |  1 | Doe       | Jane       | jd123@columbia.edu | SEAS

    And I am on the home page
    And I select "ISBN" from "search_type"
    And I fill in "query" with "978-1-1234562-13"

    Then I should be on the results page for a search with the filter "ISBN: 978-1-1234562-13"
    And  I click the result entry with title "Sample Book 1"
    Then I should be on the listings page for the book with ISBN "978-1-1234562-13"
    Then I should see "No listings available!"

Scenario: create a new listing for this book and see if it can be retrieved
    When I go to the new listing page

    And I fill in "isbn" with "978-1-1234562-13"
    And I fill in "condition" with "acceptable"
    And I fill in "price" with "20.00"
    And I fill in "class" with "COMS 4995"
    And I fill in "description" with "test lorem ipsum blah blah blah."
    And I press "Post"
    And I am on the listings page for the book with ISBN "978-1-1234562-13"

    Then I should see 1 listing
    And  I should see "acceptable - test lorem ipsum blah blah blah."

Scenario: read the details of the listing we just created
    Given I am on the listing page for the book with ISBN "978-1-1234562-13" and description "test lorem ipsum blah blah blah."
    Then  I should see "Seller information"
    And   I should see "test lorem ipsum blah blah blah."

Scenario: update the listing I just created for this book and check if it went through
    When I am on the listings page for the book with ISBN "978-1-1234562-13"
    And  I press "Edit"
    And  I fill in "description" with "test NEW test NEW"
    And  I fill in "price" with "17.99"
    And  I am on the listing page for the book with ISBN "978-1-1234562-13" and description "test NEW test NEW"

    Then I should see "Seller information"
    And  I should see "17.99"
    But  I should not see "20.00"
    And  I should see "test NEW test NEW"
    But  I should not see "test lorem ipsum blah blah blah."

Scenario: delete the listing I just created
    When I am on the listings page for the book with ISBN "978-1-1234562-13"
    And  I press "Delete"
    Then I should see "No listings available!"

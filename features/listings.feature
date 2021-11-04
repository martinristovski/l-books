Feature: CRUD listings

  As users of L'Books
  So that we can buy and sell books
  We want to create, retrieve, update, and delete listings

Background: books, users, and listings have been added to the database

    Given the following books exist:
      | id | title          | author         | edition | isbn             |
      |  1 | Sample Book 1  | Sample Example | 2       | 978-1-1234562-13 |

    Given the following users exist:
      | id | last_name | first_name | email              | school |
      |  1 | Doe       | Jane       | jd123@columbia.edu | SEAS   |

    And I am on the home page
    And I fill in "query" with "978-1-1234562-13"

    Then I should be on the results page for a search with the query "978-1-1234562-13"
    And  I click the result entry with title "Sample Book 1"
    Then I should be on the listings page for the book with ISBN "978-1-1234562-13"
    Then I should see "No listings available!"

Scenario: read the details of the listing 
    Given I am on the listing page for the book with ISBN "978-1-1234562-13" and description "test lorem ipsum blah blah blah."
    Then  I should see "Seller information"
    And   I should see "test lorem ipsum blah blah blah."

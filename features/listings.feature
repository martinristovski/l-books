Feature: Search for books

  As users of L'Books
  So that we can buy and sell books
  We want to search for books

Background: books, users, and listings have been added to the database

    Given the following books exist:
      | title          | authors        | edition | isbn             |
      | Sample Book 1  | Sample Example | 2       | 978-1-1234562-13 |

    Given the following users exist:
      | last_name | first_name | email              | school |
      | Doe       | Jane       | jd123@columbia.edu | SEAS   |


Scenario: Perform a search
    Given I am on the home page
    And I fill in "search" with "978-1-1234562-13"
    And I press "Go"
    Then I should be on the results page for a search with the query "978-1-1234562-13"

Feature: Search for and access listings

  As users of L'Books
  So that we can buy and sell books
  We want to search for books

Background: books and users have been added to the database

    Given the following books exist:
      | title          | authors           | edition | isbn          |
      | Sample Book 1  | Sample Example    | 2       | 9781123456213 |
      | Sample Book 2  | Sample Example II | 4       | 9781575675320 |

    Given the following users exist:
      | last_name | first_name | email              | school | password     | password_confirmation
      | Doe       | Jane       | jd123@columbia.edu | SEAS   | qwerty123456 | qwerty123456


Scenario: Perform a search by ISBN and pull up a book with no listings
  Given I am on the home page
  And I select "ISBN" from "criteria"
  And I fill in "search" with "978-1-1234562-13"
  And I press "Go"
  Then I should be on the search results page

  Then I should see "Sample Book 1"
  Then I should not see "Sample Book 2"
  Then I should see "9781123456213"
  Then I should not see "9781575675320"

  Then I click on the element with id "result-0"
  And I should see "Sample Book 1"
  And I should see "9781123456213"
  And I should see "No listings found!"
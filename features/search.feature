Feature: Search for books

  As users of L'Books
  So that we can buy and sell books
  We want to search for books

Background: books, users, courses, and BCAs have been added to the database

  Given the following books exist:
    | id | title          | authors           | edition | isbn          |
    |  1 | Sample Book 1  | Sample Example    | 2       | 9781123456213 |
    |  2 | Sample Book 2  | Sample Example II | 4       | 9781575675320 |

  Given the following courses exist:
    | id | code       | name              |
    |  1 | COMS W4995 | Engineering ESaaS |
    |  2 | COMS W9999 | Example Course    |

  Given the following book-course associations exist:
    | book_id | course_id |
    | 1       | 1         |
    | 2       | 2         |


Scenario: Perform a search by ISBN
  Given I am on the home page
  And I select "ISBN" from "criteria"
  And I fill in "search" with "978-1-1234562-13"
  And I press "Go"
  Then I should be on the search results page

  Then I should see "Sample Book 1"
  Then I should not see "Sample Book 2"
  Then I should see "9781123456213"
  Then I should not see "9781575675320"

Scenario: Perform a search by title
  Given I am on the home page
  And I select "Title/Author" from "criteria"
  And I fill in "search" with "Sample Book 1"
  And I press "Go"
  Then I should be on the search results page

  Then I should see "Sample Book 1"
  Then I should not see "Sample Book 2"
  Then I should see "9781123456213"
  Then I should not see "9781575675320"

Scenario: Perform a search by PARTIAL title and return multiple results
  Given I am on the home page
  And I select "Title/Author" from "criteria"
  And I fill in "search" with "Sample Book"
  And I press "Go"
  Then I should be on the search results page

  Then I should see "Sample Book 1"
  Then I should see "Sample Book 2"
  Then I should see "9781123456213"
  Then I should see "9781575675320"

Scenario: Perform a search by course code
  Given I am on the home page
  And I select "Course Number" from "criteria"
  And I fill in "search" with "COMS W4995"
  And I press "Go"
  Then I should be on the search results page

  Then I should see "Sample Book 1"
  Then I should not see "Sample Book 2"
  Then I should see "9781123456213"
  Then I should not see "9781575675320"

Scenario: Perform a search by partial course code
  Given I am on the home page
  And I select "Course Number" from "criteria"
  And I fill in "search" with "COMS"
  And I press "Go"
  Then I should be on the search results page

  Then I should see "Sample Book 1"
  Then I should see "Sample Book 2"
  Then I should see "9781123456213"
  Then I should see "9781575675320"

Scenario: Perform a search by course name
  Given I am on the home page
  And I select "Course Number" from "criteria"
  And I fill in "search" with "Engineering ESaaS"
  And I press "Go"
  Then I should be on the search results page

  Then I should see "Sample Book 1"
  Then I should not see "Sample Book 2"
  Then I should see "9781123456213"
  Then I should not see "9781575675320"

Scenario: Perform a search by partial course name
  Given I am on the home page
  And I select "Course Number" from "criteria"
  And I fill in "search" with "ESaaS"
  And I press "Go"
  Then I should be on the search results page

  Then I should see "Sample Book 1"
  Then I should not see "Sample Book 2"
  Then I should see "9781123456213"
  Then I should not see "9781575675320"

Scenario: Perform a search with no query
  Given I am on the home page
  And   I press "Go"
  Then  I should be on the home page
  And   I should see "Please enter a search term."

Scenario: Perform a search for an ISBN that does not exist
  Given I am on the home page
  And I select "ISBN" from "criteria"
  And I fill in "search" with "020202020"
  And I press "Go"
  Then I should be on the search results page

  Then I should not see "Sample Book 1"
  Then I should not see "Sample Book 2"
  Then I should not see "9781123456213"
  Then I should not see "9781575675320"

Scenario: Perform a search for a title/author that does not exist
  Given I am on the home page
  And I select "Title/Author" from "criteria"
  And I fill in "search" with "abc"
  And I press "Go"
  Then I should be on the search results page

  Then I should not see "Sample Book 1"
  Then I should not see "Sample Book 2"
  Then I should not see "9781123456213"
  Then I should not see "9781575675320"

Scenario: Perform a search for a course that does not exist
  Given I am on the home page
  And I select "Course Number" from "criteria"
  And I fill in "search" with "abc"
  And I press "Go"
  Then I should be on the search results page

  Then I should not see "Sample Book 1"
  Then I should not see "Sample Book 2"
  Then I should not see "9781123456213"
  Then I should not see "9781575675320"

Scenario: Attempt to go to the search results page directly
  Given I go to the search results page
  Then  I should be on the home page
  And   I should see "Invalid search."
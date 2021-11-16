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
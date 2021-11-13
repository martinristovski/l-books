Feature: Search for books

  As users of L'Books
  So that we can buy and sell books
  We want to search for books

Background: books, users, courses, and BCAs have been added to the database

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

Scenario: Pull up a book's information page for a book with no listings
  Given I am on the book view page for "Sample Book 1"
  Then I should see "Sample Book 1"
  Then I should see "9781123456213"
  Then I should see "No listings found!"

Scenario: Pull up a book's information page for a non-existent book
  Given I am on the book view page for a book with ID "4"
  Then  I should be on the home page
  And   I should see "Sorry, we couldn't find a book with that ID."
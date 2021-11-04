Feature: contact sellers about listings

  As users of L'Books
  So that we can buy books
  We want to be able to contact sellers about listings

Background: books and users have been added to the database

    Given the following books exist:
      | id | title          | author         | edition | isbn             |
      |  1 | The Iliad      | Homer          | 2       | 978-1-1234562-11 |

    Given the following users exist:
      | id | last_name | first_name | UNI    | email              | school | reputation |
      |  1 | Doe       | Jane       | jd123  | jd123@columbia.edu | SEAS   | 3/5        |

    And  I am on the home page
    And  I select "ISBN" from "search_type"
    And  I fill in "query" with "978-1-1234562-11"

    Then I should be on the results page for a search with the filter "ISBN: 978-1-1234562-11"
    And  I click the result entry with title "The Iliad"
    Then I should be on the listings page for the book with ISBN "978-1-1234562-11"
    Then I should see "No listings available!"

Scenario: create a new listing for this book
    When I go to the new listing page

    And  I fill in "isbn" with "978-1-1234562-11"
    And  I fill in "condition" with "acceptable"
    And  I fill in "price" with "20.00"
    And  I fill in "class" with "Lit Hum"
    And  I fill in "description" with "test description"
    And  I press "Post"
    And  I am on the listings page for the book with ISBN "978-1-1234562-11"

    Then I should see 1 listing
    And  I should see "test description"

Scenario: contact the seller of the listing we just created
    When I go to the new listing page for the book with ISBN "978-1-1234562-11" and description "test description"
    And  I press "Contact Seller"
    Then I should see "jd123@columbia.edu"

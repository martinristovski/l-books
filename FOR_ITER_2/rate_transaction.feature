Feature: Rate transactions between users

  As users of L'Books
  So that we can determine trustworthy and reliable sellers
  We want to rate transactions between ourselves and sellers of listings

Background: users and books have been added to the database

    Given the following books exist:
      | id | title          | author         | edition | isbn             |
      |  1 | The Iliad      | Homer          | 2       | 978-1-1234562-11 |

    Given the following users exist:
      | id | last_name | first_name | UNI    | email              | school | reputation |
      |  1 | Doe       | Jane       | jd123  | jd123@columbia.edu | SEAS   | 2/5        |
      |  2 | Johnson   | Alice      | aj456  | aj456@columbia.edu | CC     | 4/5        |
      |  3 | Wilkes    | Bob        | bw789  | bw789@columbia.edu | GS     | 5/5        |

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

Scenario: rate transaction from the user who is selling the listing
    When I go to the listing page for the book with ISBN "978-1-1234562-11" and description "test description"
    And  I press "Rate Transaction"
    And  I fill in "4/5"
    And  I press "Submit!"
    
    And  I am on the users page for the user with UNI "jd123"
    Then I should see "3/5"
    But  I should not see "2/5"

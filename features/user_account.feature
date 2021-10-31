Feature: CRUD user accounts

  As users of L'Books
  So that we can buy and sell books
  We want to create, retrieve, update, and delete user accounts

Background: users have been added to the database

    Given the following users exist:
      | id | last_name | first_name | UNI    | email              | school | reputation |
      |  1 | Doe       | Jane       | jd123  | jd123@columbia.edu | SEAS   | 3/5        |
      |  2 | Johnson   | Alice      | aj456  | aj456@columbia.edu | CC     | 4/5        |
      |  3 | Wilkes    | Bob        | bw789  | bw789@columbia.edu | GS     | 5/5        |

    And I am on the home page
    Then 3 seed users should exist

Scenario: create a new account for this user and see if it can be retrieved
    When I go to the new user account page

    And I fill in "name" with "Carl Matthews"
    And I fill in "UNI" with "cm246"
    And I fill in "Affiliation" with "SEAS"
    And I fill in "Email" with "cm246@columbia.edu"
    And I fill in "Reputation" with "4.5/5"
    And I press "Create Account"
    And I am on the users page for the user with UNI "cm246"

    Then I should see 1 user
    And  I should see "4.5/5"

Scenario: read the account information of the account we just created
    Given I am on the users page for the user with UNI "cm246"
    Then  I should see "User information"
    And   I should see "4.5/5"

Scenario: update the account I just created for this user and check if it was updated
    When I am on the users page for the user with UNI "cm246"
    And  I press "Edit"
    And  I fill in "reputation" with "3.5/5"
    And  I press "Update!"
    And  I am on the users page for the user with UNI "cm246"

    Then I should see "User information"
    And  I should see "3.5/5"
    But  I should not see "4.5/5"

Scenario: delete the user I just created
    When I am on the users page for the user with UNI "cm246"
    And  I press "Delete"
    Then I should see "jd123"
    And  I should see "aj456"
    And  I should see "bw789"
    But  I should not see "cm246"

Feature: View listing information

  As users of L'Books
  So that we can buy and sell books
  We want to look at listing information

  Background: books, users, courses, BCAs, and listings have been added to the database

    Given the following books exist:
      | id | title          | authors           | edition | isbn          | image_id |
      |  1 | Sample Book 1  | Sample Example    | 2       | 9781123456213 | id_1     |
      |  2 | Sample Book 2  | Sample Example II | 4       | 9781575675320 | id_2     |

    Given the following courses exist:
      | id | code       |
      |  1 | COMSW4995  |
      |  2 | COMSW9999  |

    Given the following book-course associations exist:
      | book_id | course_id |
      | 1       | 1         |
      | 2       | 2         |

  Scenario: Create a new user account with improper email format
    Given I am on the home page
    And I follow "Register"
    Then I should be on the signup page

    When I fill in "user_email" with "test1234@gmail.com"
    And I fill in "user_first_name" with "test"
    And I fill in "user_last_name" with "user"
    And I fill in "user_uni" with "test1234"
    And I fill in "user_school" with "SEAS"
    And I fill in "user_password" with "password1000"
    And I fill in "user_password_confirmation" with "password1000"
    And I press "Sign Up"
    Then I should be on the signup page
    And I should see "Email Please use your Columbia email address."

  Scenario: Create a new user account successfully
    Given I am on the home page
    And I follow "Register"
    Then I should be on the signup page

    When I fill in "user_email" with "test1234@columbia.edu"
    And I fill in "user_first_name" with "test"
    And I fill in "user_last_name" with "user"
    And I fill in "user_uni" with "test1234"
    And I fill in "user_school" with "SEAS"
    And I fill in "user_password" with "password1000"
    And I fill in "user_password_confirmation" with "password1000"
    And I press "Sign Up"

    And I should see "Successfully created account"

    And I follow "Sign Out"
    Then I should see "Logged Out"

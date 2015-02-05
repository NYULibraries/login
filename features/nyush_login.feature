@vcr
Feature: NYU Shanghai Login
  In order to use NYU Libraries' online services
  As an NYU user in Shanghai with a NetID
  I want to login with my NYU NetID and password on NYU's central login page

  Scenario: Logging in with NYU NetID and Password
    Given I am on the NYU Shanghai login page
    When I click on the "NYU" button
    And NYU Home authenticates me
    Then I should be logged in as an NYU user

  @ignore_user_keys
  Scenario: Logging in with Bobst Affiliate patron ID
    Given I am on the NYU Shanghai login page
    When I click on the "Other Borrowers" button
    And I enter my Library Patron ID for "Bobst Affiliate" and first four letters of my last name
    Then I should be logged in as a Bobst Affiliate user

  Scenario: Logging in with incorrect Bobst Affiliate patron ID
    Given I am on the NYU Shanghai login page
    When I click on the "Other Borrowers" button
    And I incorrectly enter my Library Patron ID and first four letters of my last name
    Then I should not be logged in as a Bobst Affiliate user

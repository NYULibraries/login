@vcr
Feature: Bobst Affiliate login
  In order to use NYU Libraries' online services
  As a Bobst Affiliate user
  I want to login with my Bobst Affiliate patron ID

  @ignore_user_keys
  Scenario: Logging in with Bobst Affiliate patron ID
    Given I am on the NYU New York login page
    When I click on the "Other Borrowers" button
    And I enter my Library Patron ID for "Bobst Affiliate" and first four letters of my last name
    And I am on my user page
    Then I should be logged in as a Bobst Affiliate user

  Scenario: Logging in with incorrect Bobst Affiliate patron ID
    Given I am on the NYU New York login page
    When I click on the "Other Borrowers" button
    And I incorrectly enter my Library Patron ID and first four letters of my last name
    Then I should not be logged in as a Bobst Affiliate user

  @ignore_user_keys
  Scenario: Logging out of a Bobst Affiliate account
    Given I am on the NYU New York login page
    When I click on the "Other Borrowers" button
    And I enter my Library Patron ID for "Bobst Affiliate" and first four letters of my last name
    And I visit the "NYU New York" log-out url
    Then I should be on the Bobst Affiliate logged out page

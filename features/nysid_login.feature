@vcr
Feature: New York School of Interior Design login
  In order to use NYU Libraries' online services
  As a New York School of Interior Design user
  I want to login with my NYSID patron ID

  @ignore_user_keys
  Scenario: Logging in with NYSID patron ID
    Given I am on the NYSID login page
    When I click on the "NYSID" button
    And I enter my Library Patron ID for "NYSID" and first four letters of my last name
    Then I should be logged in as a New York School of Interior Design user

  Scenario: Logging in with incorrect NYSID patron ID
    Given I am on the NYSID login page
    When I click on the "NYSID" button
    And I incorrectly enter my Library Patron ID and first four letters of my last name
    Then I should not be logged in as a New York School of Interior Design user

  @ignore_user_keys
  Scenario: Logging out of a NYSID account
    Given I am on the NYSID login page
    When I click on the "NYSID" button
    And I incorrectly enter my Library Patron ID and first four letters of my last name
    And I visit the "NYSID" log-out url
    Then I should be on the NYSID logged out page

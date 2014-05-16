@vcr
Feature: New York School of Interior Design login
  In order to use NYU Libraries' online services
  As a New York School of Interior Design user
  I want to login with my NYSID patron ID

  Scenario: Logging in with NYSID patron ID
    Given I am at NYSID
    When I want to login to NYSID
    And I enter my Library Patron ID and first four letters of my last name
    Then I should be logged in as a New York School of Interior Design user

  Scenario: Logging in with incorrect NYSID patron ID
    Given I am at NYSID
    When I want to login to NYSID
    And I incorrectly enter my Library Patron ID and first four letters of my last name
    Then I should not be logged in as a New York School of Interior Design user

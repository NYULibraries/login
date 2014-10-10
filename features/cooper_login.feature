@vcr
Feature: Cooper Union login
  In order to use NYU Libraries' online services
  As a Cooper Union user
  I want to login with my Library patron ID and first four letters of my last name

  @ignore_user_keys
  Scenario: Logging in with Cooper Union Library patron ID and first four letters of my last name
    Given I am on the Cooper Union login page
    When I click on the "Cooper Union" button
    And I enter my Library Patron ID for "Cooper Union" and first four letters of my last name
    Then I should be logged in as a Cooper Union user

  Scenario: Logging in with incorrect Cooper Union Library patron ID and first four letters of my last name
    Given I am on the Cooper Union login page
    When I click on the "Cooper Union" button
    And I incorrectly enter my Library Patron ID and first four letters of my last name
    Then I should not be logged in as a Cooper Union user
    And I should get an informative message about my incorrect credentials

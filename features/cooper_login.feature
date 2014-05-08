Feature: Cooper Union login
  In order to use NYU Libraries' online services
  As a Cooper Union user
  I want to login with my Library patron ID and first four letters of my last name

  Scenario: Logging in with Cooper Union Library patron ID and first four letters of my last name
    Given I am at Cooper Union
    When I want to login to Cooper Union
    And I enter my Library Patron ID and first four letters of my last name
    Then I should be logged in as a Cooper Union user

  Scenario: Logging in with incorrect Cooper Union Library patron ID and first four letters of my last name
    Given I am at Cooper Union
    When I want to login to Cooper Union
    And I incorrectly enter my Library Patron ID and first four letters of my last name
    Then I should not be logged in as a Cooper Union user
    And I should get an informative message about my incorrect credentials

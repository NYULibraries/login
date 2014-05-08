Feature: Cooper Union login
  In order to use NYU Libraries' online services
  As a Cooper Union user
  I want to login with my Library patron ID and first four letters of my last name

  @skip
  Scenario: Logging in with Cooper Union Library patron ID and first four letters of my last name
    Given I am at Cooper Union
    When I want to login to Cooper Union
    And I enter my Library Patron ID and first four letters of my last name
    Then I should be logged in as a Cooper Union user

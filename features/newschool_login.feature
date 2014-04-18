Feature: New School login
  In order to use NYU Libraries' online services
  As a New School user
  I want to login with my New School NetID and password

  @skip
  Scenario: Logging in with New School NetID and password
    When I want to login with my New School account
    And I enter my New School NetID and password
    Then I should be logged in as a New School user

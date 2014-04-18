Feature: NYU Shanghai Login
  In order to use NYU Libraries' online services
  As an NYU user in Shanghai with a NetID
  I want to login with my NYU NetID and password on NYU's central login page

  Scenario: Logging in with NYU NetID and Password
    Given I am on the NYU Shanghai login page
    When I click on the torch logo
    And I am redirected to NYU Home
    And I enter my NYU NetID and password
    Then I should be redirected to the Libraries' login page
    And I should not be logged in as an NYU Shanghai user

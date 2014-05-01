Feature: NYU Login
  In order to use NYU Libraries' online services
  As an NYU user in New York with a NetID
  I want to login with my NYU NetID and password on NYU's central login page

  Scenario: Logging in with NYU NetID and Password
    Given I am on the NYU New York login page
    When I click on the torch logo for NYU New York
    And I am redirected to NYU Home
    And I enter my NYU NetID and password
    Then I should be redirected to the NYU New York login page
    And I should be logged in as an NYU New York user

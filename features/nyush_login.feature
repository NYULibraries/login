@vcr
Feature: NYU Shanghai Login
  In order to use NYU Libraries' online services
  As an NYU user in Shanghai with a NetID
  I want to login with my NYU NetID and password on NYU's central login page

  Scenario: Logging in with NYU NetID and Password
    Given I am on the NYU Shanghai login page
    When I click on the NYU NetID "Click to Login" button
    And NYU Home authenticates me
    Then I should be logged in as an NYU user

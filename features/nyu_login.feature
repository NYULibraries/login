@aleph_bor_info
Feature: NYU Login
  In order to use NYU Libraries' online services
  As an NYU user in New York with a NetID
  I want to login with my NYU NetID and password on NYU Home

  Scenario: Logging in with NYU NetID and Password
    Given I am on the NYU New York login page
    When I click on the NYU NetID "Click to Login" button
    And NYU Home authenticates me
    Then I should be logged in as an NYU user

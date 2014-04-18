Feature: NYU Abu Dhabi Login
  In order to use NYU Libraries' online services
  As an NYU user in Abu Dhabi with a NetID
  I want to login with my NYU NetID and password on NYU's central login page

  Scenario: Logging in with NYU NetID and Password
    Given I am on the NYU Abu Dhabi login page
    When I click on the torch logo
    And I am redirected to the NYU central login page
    And I enter my NYU NetID and password correctly
    Then I should be redirected to the Libraries' central login page
    And I should be logged in as an NYU Abu Dhabi user

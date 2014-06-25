@omniauth_test
Feature: Login as an OAuth2 Provider
  In order to use a specific NYU Libraries' online service
  As a user
  I want to login on NYU's central login page and be logged into that specific service

  Scenario: Authorizing a logged in user to a client application
    Given I have previously logged in to Login as an NYU Shibboleth user
    And I am on an NYU client application
    When I click "Login" on the client application
    Then I should be logged in to the NYU client application

  Scenario: Logging into a client application
    Given I am logged out
    And I am on an NYU client application
    When I click "Login" on the client application
    Then I should see the Login page
    When I login to Login as an NYU Shibboleth user
    Then I should be logged in to the NYU client application

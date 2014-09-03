@omniauth_test 
Feature: Present the login page to an OAuth2 client application
  In order to ensure that I am being authenticated by NYU Libraries' Login
  As a user of the OAuth2 client application
  I want to be presented with the Login screen when I try to login to an OAuth2 client application

  Scenario: A logged out user is presented with a login screen
    Given I am logged out
    And I am on an OAuth2 client application
    When I click "Login"
    Then I should see the Login page

  Scenario: A logged in user is not asked to login again
    Given I have previously logged in to Login as an NYU Shibboleth user
    And I am on an OAuth2 client application
    When I click "Login"
    Then I should not see the Login page
    But I should be logged in to the OAuth2 client application

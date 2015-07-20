@omniauth_test @vcr
Feature: Authenticate as an OAuth2 client application
  In order to use an OAuth2 client application with Login as a provider
  As a user of the OAuth2 client application
  I want to login on NYU's central login page and be logged into the OAuth2 client application

  Scenario: A logged out user should be able to login
    Given I am logged out
    And I am on an OAuth2 client application
    When I login to Login as an NYU Shibboleth user
    Then I should be logged in to the OAuth2 client application

  Scenario: A logged in user should be authenticated for an OAuth2 client application
    Given I have previously logged in to Login as an NYU Shibboleth user
    And I am on an OAuth2 client application
    When I click "Login"
    Then I should be logged in to the OAuth2 client application

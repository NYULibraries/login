@omniauth_test @vcr
Feature: Authorize an OAuth2 client application
  In order to allow an OAuth2 client application to have access to exposed user attributes
  As a user of the OAuth2 client application
  I want to automatically authorize an OAuth2 client application to get user attributes from Login

  Scenario: A logged out user is not authorized
    Given I am logged out
    And I am on an OAuth2 client application
    Then the OAuth2 client should not have access to exposed attributes

  Scenario: A logged in user is authorized
    Given I have previously logged in to Login as an NYU Shibboleth user
    And I am on an OAuth2 client application
    When I click "Login"
    Then I should be automatically authorized to use Login as my provider
    And the OAuth2 client should have access to exposed attributes

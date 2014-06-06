@omniauth_test
Feature: Login as an OAuth2 Provider
  In order to use a specific NYU Libraries' online service
  As a user
  I want to login on NYU's central login page and be logged into that specific service

  @client_app
  Scenario: Logging into a client application
    Given I am on an NYU client application
    When I login
    Then NYU Libraries' Login authenticates me
    And I should be logged in to the NYU client application

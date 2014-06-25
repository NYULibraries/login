@omniauth_test
Feature: Get attributes from protected API when user is authenticated
  In order to have an identity in an NYU client applications
  As an authenticated user
  I want to get the user's identity attributes from the protected API in Login

  Scenario: Logging in with New School LDAP
    Given I am logged in as a New School LDAP user
    When I request my attributes from the protected API
    Then I retrieve the attributes as JSON:
      | NetID       |
      | Given Name  |
      | Surname     |
      | N Number    |
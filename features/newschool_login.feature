@omniauth_test
Feature: New School login
  In order to use NYU Libraries' online services
  As a New School user
  I want to login with my New School NetID and password

  Scenario: Logging in with valid credentials
    Given I am on the New School login page
    When I submit my New School NetID and password
    And New School LDAP authenticates me
    Then I should be logged in as a New School user

  Scenario: Logging in with invalid credentials
    Given I am on the New School login page
    When I submit invalid New School credentials
    Then I should see the error message "Invalid credentials"

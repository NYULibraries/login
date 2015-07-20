@omniauth_test @vcr
Feature: New School login
  In order to use NYU Libraries' online services
  As a New School user
  I want to login with my New School NetID and password

  Scenario: Logging in with valid credentials
    Given I am on the New School login page
    When I click on the "The New School" button
    And I submit my New School NetID and password
    And New School LDAP authenticates me
    And I am on my user page
    Then I should be logged in as a New School user

  Scenario: Logging in with invalid credentials
    Given I am on the New School login page
    When I click on the "The New School" button
    And I submit invalid New School credentials
    Then I should see the error message "You may have entered your information incorrectly or you do not have access to this resource"

  Scenario: Logging out of a New School Library account
    Given I am on the New School login page
    When I click on the "The New School" button
    And New School LDAP authenticates me
    And I visit the "New School" log-out url
    Then I should be on the New School logged out page

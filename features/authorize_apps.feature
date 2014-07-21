@omniauth_test
Feature: Adding client applications.
  As an admin of the Login application.
  I want to be able to add client applications.

  Scenario: Adding client applications as a logged in admin.
    Given I am logged in as a "NYU Shibboleth" admin
    When I go to the client applications page
    Then I should have access to the list of applications
    When I click add new application
    And I add the application
    Then I should see that the application is added

  Scenario: Trying to add client application as a logged in user.
    Given I am logged in as a "New School LDAP" user
    When I go to the client applications page
    Then I should not have access to the list of applications

  Scenario: Trying to add client application as a logged out user.
    Given I am a logged out user
    When I go to the client applications page
    Then I should not have access to the list of applications

@vcr
Feature: NYU Shanghai Login
  In order to use NYU Libraries' online services
  As an NYU user in Shanghai with a NetID
  I want to login with my NYU NetID and password on NYU's central login page

  Background:
    Given I am logged out

  Scenario: Logging in with NYU NetID and Password
    Given I am on the NYU Shanghai login page
    When I click on the "NYU" button
    And NYU Home authenticates me as an "NYU Shanghai" user
    Then I should be logged in as an NYU Shanghai user

  @ignore_user_keys
  Scenario: Logging in with Bobst Affiliate patron ID
    Given I am on the NYU Shanghai login page
    When I click on the "Other Borrowers" button
    And I enter my Library Patron ID for "Bobst Affiliate" and first four letters of my last name
    Then I should be logged in as a Bobst Affiliate user

  Scenario: Logging in with incorrect Bobst Affiliate patron ID
    Given I am on the NYU Shanghai login page
    When I click on the "Other Borrowers" button
    And I incorrectly enter my Library Patron ID and first four letters of my last name
    Then I should not be logged in as a Bobst Affiliate user

  Scenario: Logging out of an NYU Shanghai account
    Given I am on the NYU Shanghai login page
    When I click on the "NYU" button
    And NYU Home authenticates me as an "NYU Shanghai" user
    And I visit the "NYU Shanghai" log-out url
    Then I should be on the NYU Shanghai logged out page

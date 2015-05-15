@vcr
Feature: NYU Abu Dhabi Login
  In order to use NYU Libraries' online services
  As an NYU user in Abu Dhabi with a NetID
  I want to login with my NYU NetID and password on NYU's central login page

  Background:
    Given I am logged out

  Scenario: Logging in with NYU NetID and Password
    Given I am on the NYU Abu Dhabi login page
    When I click on the "NYU" button
    And NYU Home authenticates me as an "NYU Abu Dhabi" user
    Then I should be logged in as an NYU Abu Dhabi user

  @ignore_user_keys
  Scenario: Logging in with Bobst Affiliate patron ID
    Given I am on the NYU Abu Dhabi login page
    When I click on the "Other Borrowers" button
    And I enter my Library Patron ID for "Bobst Affiliate" and first four letters of my last name
    Then I should be logged in as a Bobst Affiliate user

  Scenario: Logging in with incorrect Bobst Affiliate patron ID
    Given I am on the NYU Abu Dhabi login page
    When I click on the "Other Borrowers" button
    And I incorrectly enter my Library Patron ID and first four letters of my last name
    Then I should not be logged in as a Bobst Affiliate user

  Scenario: Logging out of an NYU Abu Dhabi account
    Given I am on the NYU Abu Dhabi login page
    When I click on the "NYU" button
    And NYU Home authenticates me as an "NYU Abu Dhabi" user
    And I visit the "NYU Abu Dhabi" log-out url
    Then I should be on the NYU Abu Dhabi logged out page

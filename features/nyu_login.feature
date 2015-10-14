@vcr
Feature: NYU Login
  In order to use NYU Libraries' online services
  As an NYU user in New York with a NetID
  I want to login with my NYU NetID and password on NYU Home

  Background:
    Given I am logged out

  Scenario: Logging in with NYU NetID and Password
    Given I am on the NYU New York login page
    When I click on the "NYU" button
    And NYU Home authenticates me
    And I am on my user page
    Then I should be logged in as an NYU New York user

  Scenario: Logging out of an NYU account
    Given I am on the NYU New York login page
    When I click on the "NYU" button
    And NYU Home authenticates me
    And I visit the "NYU New York" log-out url
    Then I should be on the NYU New York logged out page

  Scenario: Attempting to visit the root page after logging in
    Given I am on the NYU New York login page
    When I click on the "NYU" button
    And NYU Home authenticates me
    And I visit the root url
    Then I should be redirected to "https://dev.login.library.nyu.edu/login"

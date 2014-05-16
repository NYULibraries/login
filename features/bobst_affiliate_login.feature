@vcr
Feature: Bobst Affiliate login
  In order to use NYU Libraries' online services
  As a Bobst Affiliate user
  I want to login with my Bobst Affiliate patron ID

  Scenario: Logging in with Bobst Affiliate patron ID
    Given I am on the NYU New York login page
    When I want to login to Bobst Affiliate
    And I enter my Library Patron ID and first four letters of my last name
    Then I should be logged in as a New York School of Interior Design user

  Scenario: Logging in with incorrect Bobst Affiliate patron ID
    Given I am on the NYU New York login page
    When I want to login to Bobst Affiliate
    And I incorrectly enter my Library Patron ID and first four letters of my last name
    Then I should not be logged in as a New York School of Interior Design user

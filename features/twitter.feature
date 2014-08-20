@vcr @wip
Feature: Twitter login
  In order to use NYU Libraries' online services
  As a visitor at Bobst Library with a Twitter account
  I want to login with my Twitter credentials on the Libraries' login page

  Scenario: Logging in with Twitter account
    Given I am on the NYU New York login page
    And I should see an option to login with a Twitter account
    When I click on the "Twitter" button
    And Twitter authenticates me
    And I've authorized Twitter to share my information with NYU Libraries
    And I wait up to 30 seconds for twitter to redirect me
    Then I should be logged in with my Twitter handle

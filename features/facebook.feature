@vcr
Feature: Twitter login
  In order to use NYU Libraries' online services
  As a visitor at Bobst Library with a Facebook account
  I want to login with my Facebook credentials on the Libraries' login page

  Scenario: Logging in with Twitter account
    Given I am on the NYU New York login page
    And I should see an option to login with a Facebook account
    When I click on the "Facebook" button
    And Facebook authenticates me
    And I've authorized Facebook to share my information with NYU Libraries
    And I wait up to 30 seconds for Facebook to redirect me
    Then I should be logged in with my Facebook handle

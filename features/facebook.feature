@vcr
Feature: Facebook login
  In order to use NYU Libraries' online services
  As a visitor at Bobst Library with a Facebook account
  I want to login with my Facebook credentials on the Libraries' login page

  Scenario: Logging in with Facebook account
    Given I am on the NYU New York login page
    When I click on the "Visitors" button
    And I click on the "Facebook" button
    And I wait for facebook login page
    And Facebook authenticates me
    Then I should be logged in with my Facebook handle

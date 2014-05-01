Feature: Twitter login
  In order to use NYU Libraries' online services
  As an NYU user in New York with a Twitter account
  I want to login with my Twitter credentials on NYU's central login page

  Scenario: Logging in with Twitter account
    Given I am on the NYU New York login page
    And I should see an option to login with a Twitter account
    When I click on the "Twitter" button
    And I am redirected to a Twitter login page
    And I enter my Twitter credentials
    Then I should be redirected to the Libraries' login page
    And I should be logged in as an NYU New York user

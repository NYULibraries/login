Feature: Visitors authentication page
  In order to use NYU Libraries' online services
  As a visiting user
  I want to be able to get to the Visitors login page regardless of where I am

  Scenario: Log in as a Visitor patron from off campus
    Given I am off campus
    When I want to login
    And I press the Visitors login option
    Then I should go to the Visitors authentication page
    And I should be able to login with a Twitter account

  Scenario: Log in as a Visitor patron from NYU, New York
    Given I am at NYU New York
    When I want to login
    And I press the Visitors login option
    Then I should go to the Visitors authentication page
    And I should be able to login with a Twitter account

  Scenario: Log in as a Visitor patron from New School
    Given I am at New School
    When I want to login
    And I press the Visitors login option
    Then I should go to the Visitors authentication page
    And I should be able to login with a Twitter account

  Scenario: Log in as a Visitor patron from NYSID
    Given I am at NYSID
    When I want to login
    And I press the Visitors login option
    Then I should go to the Visitors authentication page
    And I should be able to login with a Twitter account

  Scenario: Log in as a Visitor patron from Cooper Union
    Given I am at Cooper Union
    When I want to login
    And I press the Visitors login option
    Then I should go to the Visitors authentication page
    And I should be able to login with a Twitter account

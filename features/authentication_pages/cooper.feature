Feature: Cooper Union authentication page
  In order to use NYU Libraries' online services
  As a Cooper Union user
  I want to be able to get to the Cooper Union login page regardless of where I am

  Scenario: Log in as a Cooper Union patron from Cooper Union
    Given I am at Cooper Union
    When I want to login
    And I press the Cooper Union login option
    Then I should go to the Cooper Union authentication page
    And I should be able to login with a Cooper Union account

  Scenario: Log in as a Cooper Union patron from off campus
    Given I am off campus
    When I want to login
    And I press the Cooper Union login option
    Then I should go to the Cooper Union authentication page
    And I should be able to login with a Cooper Union account

  Scenario: Log in as a Cooper Union patron from NYU, New York
    Given I am at NYU New York
    When I want to login
    And I press the Cooper Union login option
    Then I should go to the Cooper Union authentication page
    And I should be able to login with a Cooper Union account

  Scenario: Log in as a Cooper Union patron from New School
    Given I am at New School
    When I want to login
    And I press the Cooper Union login option
    Then I should go to the Cooper Union authentication page
    And I should be able to login with a Cooper Union account

  Scenario: Log in as a Cooper Union patron from NYSID
    Given I am at NYSID
    When I want to login
    And I press the Cooper Union login option
    Then I should go to the Cooper Union authentication page
    And I should be able to login with a Cooper Union account

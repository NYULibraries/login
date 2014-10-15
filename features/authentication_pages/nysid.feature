Feature: NYSID authentication page
  In order to use NYU Libraries' online services
  As a NYSID user
  I want to be able to get to the NYSID login page regardless of where I am

  Scenario: Log in as a NYSID patron from NYSID
    Given I am at NYSID
    When I want to login
    And I press the NYSID login option
    Then I should go to the NYSID authentication page
    And I should be able to login with a NYSID account

  Scenario: Log in as a NYSID patron from off campus
    Given I am off campus
    When I want to login
    And I press the NYSID login option
    Then I should go to the NYSID authentication page
    And I should be able to login with a NYSID account

  Scenario: Log in as a NYSID patron from NYU, New York
    Given I am at NYU New York
    When I want to login
    And I press the NYSID login option
    Then I should go to the NYSID authentication page
    And I should be able to login with a NYSID account

  Scenario: Log in as a NYSID patron from New School
    Given I am at New School
    When I want to login
    And I press the NYSID login option
    Then I should go to the NYSID authentication page
    And I should be able to login with a NYSID account

  Scenario: Log in as a NYSID patron from NYSID
    Given I am at Cooper Union
    When I want to login
    And I press the NYSID login option
    Then I should go to the NYSID authentication page
    And I should be able to login with a NYSID account

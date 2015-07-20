Feature: New School authentication page
  In order to use NYU Libraries' online services
  As a New School user
  I want to be able to get to the New School login page regardless of where I am

  Scenario: Log in as a New School patron from New School
    Given I am at New School
    When I want to login
    And I press the The New School login option
    Then I should go to the New School authentication page
    And I should be able to login with a New School account

  Scenario: Log in as a New School patron from off campus
    Given I am off campus
    When I want to login
    And I press the The New School login option
    Then I should go to the New School authentication page
    And I should be able to login with a New School account

  Scenario: Log in as a New School patron from NYU, New York
    Given I am at NYU New York
    When I want to login
    And I press the The New School login option
    Then I should go to the New School authentication page
    And I should be able to login with a New School account

  Scenario: Log in as a New School patron from Cooper Union
    Given I am at Cooper Union
    When I want to login
    And I press the The New School login option
    Then I should go to the New School authentication page
    And I should be able to login with a New School account

  Scenario: Log in as a New School patron from NYSID
    Given I am at NYSID
    When I want to login
    And I press the The New School login option
    Then I should go to the New School authentication page
    And I should be able to login with a New School account

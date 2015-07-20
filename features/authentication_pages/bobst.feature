Feature: Other Borrower authentication page
  In order to use NYU Libraries' online services
  As an Other Borrower user
  I want to be able to get to the Other Borrower login page regardless of where I am

  Scenario: Log in as an Other Borrower patron from off campus
    Given I am off campus
    When I want to login
    And I press the Other Borrowers login option
    Then I should go to the Other Borrower authentication page
    And I should be able to login with an Other Borrower account

  Scenario: Log in as an Other Borrower patron from NYU, New York
    Given I am at NYU New York
    When I want to login
    And I press the Other Borrowers login option
    Then I should go to the Other Borrower authentication page
    And I should be able to login with an Other Borrower account

  Scenario: Log in as an Other Borrower patron from NYU, Abu Dhabi
    Given I am at NYU Abu Dhabi
    When I want to login
    And I press the Other Borrowers login option
    Then I should go to the Other Borrower authentication page
    And I should be able to login with an NYU Abu Dhabi Other Borrower account

  Scenario: Log in as an Other Borrower patron from NYU, Shanghai
    Given I am at NYU Shanghai
    When I want to login
    And I press the Other Borrowers login option
    Then I should go to the Other Borrower authentication page
    And I should be able to login with an NYU Shanghai Other Borrower account

  Scenario: Log in as an Other Borrower patron from NYU, Health Sciences
    Given I am at NYU Health Sciences
    When I want to login
    And I press the Other Borrowers login option
    Then I should go to the Other Borrower authentication page
    And I should be able to login with an Other Borrower account

Feature: Where-are-you-from (WAYF) page
  In order to login with the appropriate account
  As a guest user
  I want to immediately recognize where I should login

  Scenario: Logging in from off campus
    Given I am off campus
    When I want to login
    Then my primary login option should be NYU
    And I should see an option to login with a New School account
    And I should see an option to login with a Cooper Union account
    And I should see an option to login with a NYSID account
    And I should see an option to login as an Other Borrower
    And I should see an option to login as a Visitor

  Scenario: Logging in from NYU, New York
    Given I am at NYU in New York
    When I want to login
    Then my primary login option should be NYU
    And I should see an option to login with a New School account
    And I should see an option to login with a Cooper Union account
    And I should see an option to login with a NYSID account
    And I should see an option to login as an Other Borrower
    And I should see an option to login as a Visitor

  Scenario: Logging in from NYU, Abu Dhabi
    Given I am at NYU in Abu Dhabi
    When I want to login
    Then my primary login option should be NYU
    And I should see an option to login as an Other Borrower
    But I should not see an option to login with a New School account
    But I should not see an option to login with a Cooper Union account
    But I should not see an option to login with a NYSID account
    But I should not see an option to login as a Visitor

  Scenario: Logging in from NYU, Shanghai
    Given I am at NYU in Shanghai
    When I want to login
    Then my primary login option should be NYU
    And I should see an option to login as an Other Borrower
    But I should not see an option to login with a New School account
    But I should not see an option to login with a Cooper Union account
    But I should not see an option to login with a NYSID account
    But I should not see an option to login as a Visitor

  Scenario: Logging in from the NYU Health Sciences Library
    Given I am at NYU Health Sciences
    When I want to login
    Then my primary login option should be NYU
    And I should see an option to login as an Other Borrower
    But I should not see an option to login with a New School account
    But I should not see an option to login with a Cooper Union account
    But I should not see an option to login with a NYSID account
    But I should not see an option to login as a Visitor

  Scenario: Logging in from the New School
    Given I am at the New School
    When I want to login
    Then my primary login option should be New School
    And I should see an option to login with an NYU account
    And I should see an option to login with a Cooper Union account
    And I should see an option to login with a NYSID account
    And I should see an option to login as a Visitor
    But I should not see an option to login as an Other Borrower

  Scenario: Logging in from Cooper Union
    Given I am at Cooper Union
    When I want to login
    Then my primary login option should be Cooper Union
    And I should see an option to login with an NYU account
    And I should see an option to login with a New School account
    And I should see an option to login with a NYSID account
    And I should see an option to login as a Visitor
    But I should not see an option to login as an Other Borrower

  Scenario: Logging in from NYSID
    Given I am at NYSID
    When I want to login
    Then my primary login option should be NYSID
    And I should see an option to login with an NYU account
    And I should see an option to login with a New School account
    And I should see an option to login with a Cooper Union account
    And I should see an option to login as a Visitor
    But I should not see an option to login as an Other Borrower

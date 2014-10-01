Feature: login choice
  In order to login with the appropriate account
  As a guest user
  I want to see my login options

  Scenario: Logging in from off campus
    Given I am off campus
    When I want to login
    Then I should see the NYU button
    And I should see an option to login with a New School account
    And I should see an option to login with a Cooper Union account
    And I should see an option to login with a NYSID account
    And I should see an option to login as an Other Borrower
    And I should see an option to login as a Visitor

  Scenario: Logging in from NYU, New York
    Given I am at NYU in New York
    # TODO: Remove location when we have IP configuration in place
    When I want to login to NYU New York
    Then I should see the NYU button
    And I should see an option to login with a New School account
    And I should see an option to login with a Cooper Union account
    And I should see an option to login with a NYSID account
    And I should see an option to login as an Other Borrower
    And I should see an option to login as a Visitor

  Scenario: Logging in from NYU, Abu Dhabi
    Given I am at NYU in Abu Dhabi
    # TODO: Remove location when we have IP configuration in place
    When I want to login to NYU Abu Dhabi
    Then I should see the NYU button
    And I should see an option to login with a New School account
    And I should see an option to login with a Cooper Union account
    And I should see an option to login with a NYSID account
    But I should not see an option to login as an Other Borrower
    But I should not see an option to login as a Visitor

  Scenario: Logging in from NYU, Shanghai
    Given I am at NYU in Shanghai
    # TODO: Remove location when we have IP configuration in place
    When I want to login to NYU Shanghai
    Then I should see the NYU button
    And I should see an option to login with a New School account
    And I should see an option to login with a Cooper Union account
    And I should see an option to login with a NYSID account
    But I should not see an option to login as an Other Borrower
    But I should not see an option to login as a Visitor

  Scenario: Logging in from the NYU Health Sciences Library
    Given I am at NYU Health Sciences
    # TODO: Remove location when we have IP configuration in place
    When I want to login to NYU Health Sciences
    Then I should see the NYU button
    And I should see an option to login with a New School account
    And I should see an option to login with a Cooper Union account
    And I should see an option to login with a NYSID account
    But I should not see an option to login as an Other Borrower
    But I should not see an option to login as a Visitor

  Scenario: Log in as a New School patron from NYU
    Given I am at NYU New York
    When I want to login
    And I press the New School login option
    Then I should go to the New School login page
    And I should be able to login with a New School account

  @wip
  Scenario: Logging in from the New School
    Given I am at the New School
    # TODO: Remove location when we have IP configuration in place
    When I want to login to the New School
    Then I should be able to login with a New School account
    And I should see an option to login with an NYU account
    And I should see an option to login with a Cooper Union account
    And I should see an option to login with a NYSID account
    But I should not see the NYU button
    But I should not see an option to login as an Other Borrower
    But I should not see an option to login as a Visitor

  @wip
  Scenario: Logging in from Cooper Union
    Given I am at Cooper Union
    # TODO: Remove location when we have IP configuration in place
    When I want to login to Cooper Union
    Then I should be able to login with a Cooper Union account
    And I should see an option to login with an NYU account
    And I should see an option to login with a New School account
    But I should not see an option to login with a NYSID account
    But I should not see the NYU button
    But I should not see an option to login as a Visitor

  @wip
  Scenario: Logging in from NYSID
    Given I am at NYSID
    # TODO: Remove location when we have IP configuration in place
    When I want to login to NYSID
    Then I should be able to login with a NYSID account
    And I should see an option to login with an NYU account
    And I should see an option to login with a New School account
    And I should see an option to login with a Cooper Union account
    But I should not see the NYU button
    But I should not see an option to login as a Visitor

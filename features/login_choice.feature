Feature: login choice
  In order to login with the appropriate account
  As a guest user
  I want to see my login options

  Scenario: Logging in at NYU, New York
    When I am at NYU in New York
    And I want to login
    Then I should see the NYU torch login button
    And I should see an option to login with a New School account
    And I should see an option to login with a Cooper Union account
    And I should see an option to login with a NYSID account
    And I should see an option to login with a Twitter account
    And I should see an option to login with a Facebook account

  Scenario: Logging in at NYU, Abu Dhabi
    When I am at NYU in Abu Dhabi
    And I want to login
    Then I should see the NYU torch login button
    And I should see an option to login with a New School account
    And I should see an option to login with a Cooper Union account
    And I should see an option to login with a NYSID account
    But I should not see an option to login with a Twitter account
    But I should not see an option to login with a Facebook account

  Scenario: Logging in at NYU, Shanghai
    When I am at NYU in Shanghai
    And I want to login
    Then I should see the NYU torch login button
    And I should see an option to login with a New School account
    And I should see an option to login with a Cooper Union account
    And I should see an option to login with a NYSID account
    But I should not see an option to login with a Twitter account
    But I should not see an option to login with a Facebook account

  Scenario: Logging in at the New School
    When I am at the New School
    And I want to login
    Then I should be able to login with a New School account
    And I should see an option to login with an NYU account
    And I should see an option to login with a Cooper Union account
    And I should see an option to login with a NYSID account
    But I should not see the NYU torch login button
    But I should not see an option to login with a Twitter account
    But I should not see an option to login with a Facebook account

  Scenario: Logging in at Cooper Union
    When I am at Cooper Union
    And I want to login
    Then I should be able to login with a Cooper Union account
    And I should see an option to login with an NYU account
    And I should see an option to login with a New School account
    But I should not see an option to login with a NYSID account
    But I should not see the NYU torch login button
    But I should not see an option to login with a Twitter account
    But I should not see an option to login with a Facebook account

  Scenario: Logging in at NYSID
    When I am at NYSID
    And I want to login
    Then I should be able to login with a NYSID account
    And I should see an option to login with an NYU account
    And I should see an option to login with a New School account
    And I should see an option to login with a Cooper Union account
    But I should not see the NYU torch login button
    But I should not see an option to login with a Twitter account
    But I should not see an option to login with a Facebook account

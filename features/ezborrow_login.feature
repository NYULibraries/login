@vcr @omniauth_test
Feature: Logging in through an EZ-Borrow route

  Scenario: throwaway
    Given I am logged in as an "Aleph" user

  Scenario: Visiting the NYU EZ-Borrow page as a logged in user with EZ-Borrow access privileges should redirect me to an EZ-Borrow.
    # Given I am an authorized EZ-Borrow patron
    Given I am logged in as an "Aleph" user
    When I visit the NYU EZ-Borrow url with query "the astd management development handbook"
    Then I should be redirected to "https://e-zborrow.relaisd2d.com/"

  @ezborrow_unauthorized
  Scenario: Visiting the NYU EZ-Borrow page as a logged in user without EZ-Borrow access privileges should redirect me to an unauthorized page.
    # Given I am an unauthorized EZ-Borrow patron
    Given I am logged in as an "Aleph" user
    When I visit the NYU EZ-Borrow url with query "the astd management development handbook"
    Then I should be redirected to "https://library.nyu.edu/errors/ezborrow-library-nyu-edu/unauthorized/"

@vcr @omniauth_test
Feature: Logging in through an EZ-Borrow route

  @wip
  Scenario: Visiting the NYU EZ-Borrow page as a logged in user with EZ-Borrow access privileges should redirect me to an EZ-Borrow.
    Given I am logged in as an "Aleph" user
    When I visit the NYU EZ-Borrow url with query "the astd management development handbook"
    Then I should be redirected to "https://library.nyu.edu/services/borrowing/from-non-nyu-libraries/e-zborrow/"

  @ezborrow_unauthorized @wip
  Scenario: Visiting the NYU EZ-Borrow page as a logged in user without EZ-Borrow access privileges should redirect me to an unauthorized page.
    Given I am logged in as an "Aleph" user
    When I visit the NYU EZ-Borrow url with query "the astd management development handbook"
    Then I should be redirected to "https://library.nyu.edu/services/borrowing/from-non-nyu-libraries/e-zborrow/"

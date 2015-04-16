@omniauth_test @vcr @after_deploy
Feature: Get attributes from protected API when user is authenticated
  In order to have an identity in an NYU client applications
  As an authenticated user
  I want to get the user's identity attributes from the protected API in Login

  Scenario: Logging in with New School LDAP
    Given I am logged in as a "New School LDAP" user
    When I request my attributes from the protected API
    Then I retrieve the attributes as JSON:
      | NetID       | snowj     |
      | Given Name  | Jon       |
      | Surname     | Snow      |
      | N Number    | BOR_ID    |

  Scenario: Logging in with NYU Shibboleth
    Given I am logged in as a "NYU Shibboleth" user
    When I request my attributes from the protected API
    Then I retrieve the attributes as JSON:
      | NetID       | js123     |
      | Given Name  | Jon       |
      | Surname     | Snow      |
      | N Number    | BOR_ID    |
      | Entitlement | nothing   |

  Scenario: Logging in with Aleph
    Given I am logged in as an "Aleph" user
    When I request my attributes from the protected API
    Then I retrieve the attributes as JSON:
      | Aleph ID       | BOR_ID         |
      | Patron Status  | 05             |
      | Patron Type    | Bastard        |
      | ILL Permission | Y              |
      | PLIF Status    | Kings Landing  |

  Scenario: Logging in with Facebook
    Given I am logged in as an "Facebook" user
    When I request my attributes from the protected API
    Then I retrieve the attributes as JSON:
      | First Name  | Jon             |
      | Last Name   | Snow            |
      | Location    | The Wall        |
      | Nickname    | jonsnow         |
      | Name        | Jon Snow        |
      | Email       | snowj@1nyu.edu  |

  Scenario: Logging in with Twitter
    Given I am logged in as an "Twitter" user
    When I request my attributes from the protected API
    Then I retrieve the attributes as JSON:
      | First Name  | Jon             |
      | Last Name   | Snow            |
      | Location    | The Wall        |
      | Nickname    | @knowsnothing   |
      | Name        | Jon Snow        |
      | Email       | snowj@1nyu.edu  |

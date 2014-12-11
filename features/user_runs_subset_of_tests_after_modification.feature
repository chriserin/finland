Feature: User runs subset of tests after modification

  Scenario:
    Given a program and a test suite
    When I run the full test suite
    Then I see the test index saved to a file
    When I make a change to a code file
    Then I see finlands affected tests
    And  I run the test suite with Finland
    Then I see only a subtest of tests were run

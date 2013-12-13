@javascript
Feature:  VIN History
        
    To view all decoded VIN
    As a user
    I want to view all VINs in the database

Background:
    Given the following vehicles:
    | vin        | make   | model | year | trim | transmission_type | engine_type | engine_cylinders | engine_size |
    | 1234567890 | Ford   | Focus | 2011 | Base | AUTOMATIC         | gas         | 4                | 2.5         |
    | 2345678901 | Toyota | Camry | 2013 | XLE  | AUTOMATIC         | gas         | 6                | 2.5         |

Scenario: As a user, I can view all VINs in the database
    When I visit the home page
    And I click "View Decoded VINs"
    Then I should see the following vehicles:
    | VIN        | Make   | Model |         |
    | 1234567890 | Ford   | Focus | Details |
    | 2345678901 | Toyota | Camry | Details |

Scenario: As a user, I can view the details of a VIN
    When I visit the home page
    And I click "View Decoded VINs"
    And I click "Details" for VIN "1234567890"
    Then I should see "1234567890"
    And I should see "Ford"
    And I should see "Focus"
    And I should see "2011"
    And the trim dropdown should contain "Base"
    And I should see "Automatic"
    And I should see "Gas"
    And I should see "4"
    And I should see "2.5"

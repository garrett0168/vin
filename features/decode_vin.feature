@javascript
Feature:  Decode VIN
        
    To decode a VIN
    As a user
    I need to submit a VIN

Scenario: As a user, I can decode a VIN
    When I visit the home page
    And I fill in "vin-input" with "ZHWUC1ZD5DLA01714"
    When I click "Decode"
    Then I should see "ZHWUC1ZD5DLA01714"
    And I should see "Lamborghini"
    And I should see "Aventador"
    And I should see "2013"
    And I should see "LP 700-4"
    And I should see "Automated Manual"
    And I should see "Gas"
    And I should see "12"
    And I should see "6.5"
    And I should see an image

Scenario: As a user, I can enter a lowercase VIN
    When I visit the home page
    And I fill in "vin-input" with "zhwuc1zd5dla01714"
    When I click "Decode"
    Then I should see "ZHWUC1ZD5DLA01714"
    And I should see "Lamborghini"
    And I should see "Aventador"
    And I should see "2013"
    And I should see "LP 700-4"
    And I should see "Automated Manual"
    And I should see "Gas"
    And I should see "12"
    And I should see "6.5"
    And I should see an image

Scenario: As a user, I can search for another VIN
    When I visit the home page
    And I fill in "vin-input" with "ZHWUC1ZD5DLA01714"
    When I click "Decode"
    Then I should see "ZHWUC1ZD5DLA01714"
    When I click "Decode Another VIN"
    Then I should see "Enter a VIN"

Scenario: As a user, I should not see an empty transmission type
    Given the following vehicles:
    | vin        | make   | model | year | trim | transmission_type | engine_type | engine_cylinders | engine_size |
    | 2345678901 | Toyota | Camry | 2013 | XLE  | AUTOMATIC         | gas         | 6                | 2.5         |
    And vin "2345678901" has no transmission_type
    When I visit the home page
    And I fill in "vin-input" with "2345678901"
    When I click "Decode"
    And I pause "2" seconds
    Then I should not see "Transmission Type"

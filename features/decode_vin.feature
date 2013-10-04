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
    When I click "Search Again"
    Then I should see "Enter a VIN"

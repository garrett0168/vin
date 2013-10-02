@javascript
Feature:  View the homepage
        
    In order to start searching for VINs
    As a user
    I need to see the homepage

Scenario: As a user, I can view the homepage
    When I visit the home page
    Then I should see "Welcome"

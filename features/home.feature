Feature: HomePage
	In order to sign-up for the service
	As a sender
	I want to see the subcription form
	
	Scenario: First time
		When I go to the homepage
		Then show me the page
		Then I should see "Formular"
		And I should see "Prenume"
		And I should see "Nume"		
		And I should see "E-Mail"
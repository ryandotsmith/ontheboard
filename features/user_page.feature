Feature: User Page
	In order to effectively manage ones account
	Users
	Want to see a page that shows all of the boards and tallies
	
	Scenario: User activates account
	  	Given the user was successfully activated 
	  	When user logs in
		Then a new page should be created 
		And they should be redirected to that page 
	  
	
	Scenario: User logs in with existing account 
		Given a user has an activated account 
		When the user logs in 
		
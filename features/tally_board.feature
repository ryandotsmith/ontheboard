Feature: Tally Board
	In order to become a wizard master 
	Users 
	Want to create a tally board to track their progress 

	Scenario: Create a new board
		Given i am logged in
		When i create a new board
		Then i should see the board attached to my username
	
	Scenario: Owner edits a board
		Given i am logged in 
		And i am the owner of a board
		When i edit the title of the board
		Then i should see the new title
	
	Scenario: User edits a board
		Given i am logged in
		And i am not the owner of a board
		When i try to edit the board
		Then i should receive an error
	
	Scenario: Non Privileged User views a public board
		Given i am logged in 
		And i am not the owner of a board 
		And i have not been granted read access to the board
		And the board is marked as public
		When i read the board
		Then i should see the title 
	
	Scenario: Non Privileged User views a private board
		Given i am logged in 
		And i am not the owner of the board 
		And i have not been added granted read access to the board
		And the board is not marked as public 
		When i read the board 
		Then i should receive an error 

	Scenario: User has read access views a private board
		Given i am logged in 
		And i am not the owner of the board 
		And i am a reader of the board
		When i access the board
		Then i should see the board 
		And i should not see any admin links
	
	Scenario: User has subscriber access to a private board
		Given i am logged in 
		And i am not the owner of the board 
		And i am a reader of the board 
		And i am a subscriber of the board 
		When i access the board 
		Then i should see the board 
		And i should not see admin links
		And i should see subscriber links 
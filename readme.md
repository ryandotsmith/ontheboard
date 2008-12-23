**make sure that you have these gems**

you can see all of your gems by running: gem list

rspec, rspec-rails, cucumber, aasm, thoughtbot-factory_girl 


**If you already have an old ontheboard directory .... remove it** 
    
	rm -rf ontheboard/


**Also, delete the repository from your github account.**

	Your github account -> Your Repositories -> ontheboard -> 
	edit -> delete this repository (located towards bottom of page)


**Fork my new repository** 

[my repo](http://github.com/ryandotsmith/ontheboard/tree/master)


**Pull up a git bash and cd into a directory where you save your code**

	git clone git@github.com:_YourAccountName_/ontheboard.git
	
	cd ontheboard 
	
	cp config/database.example config/database.yml
	
	git submodule init
	
	git submodule update
	
	rake db:create:all
	
	rake db:migrate
	
	rake db:test:prepare
	
	rake spec

**you should have seen a bunch (266) of tests pass!**



###############################################################
Given /^i am logged in$/ do
  @current_user = User.create!(
      :name => 'quentin',
      :email => 'joe@shmoe.com',
      :login => 'loginz',
      :password => 'monkey',
      :password_confirmation => 'monkey',
      :activated_at => '2008-11-22 12:13:59',
      :activation_code => nil,
      :salt => '356a192b7913b04c54574d18c28d46e6395428ab',
      :crypted_password => 'df42adbd0b4f7d31af495bcd170d4496686aecb1',
      :created_at => '2008-11-22 12:13:59')
    @current_user.should_not eql( nil )
end

When /^i create a new board$/ do
  @current_user.boards << Board.create!(:title => "become a wizzard")
end

Then /^i should see the board attached to my username$/ do
  my_board = Board.find_by_title("become a wizzard")
  @current_user.boards.include?( my_board ).should eql( true )
end
###############################################################
Given /^i am the owner of a board$/ do
  my_board.can_write( @current_user ).should eql( true )
end

When /^i edit the title of the board$/ do
  
end

Then /^i should see the new title$/ do
end
###############################################################
Given /^i am not the owner of a board$/ do
end

When /^i try to edit the board$/ do
end

Then /^i should receive an error$/ do
end
###############################################################
Given /^i have not been granted read access to the board$/ do
end
###############################################################
Given /^the board is marked as public$/ do
end

When /^i read the board$/ do
end

Then /^i should see the title$/ do
end
###############################################################
Given /^i am not the owner of the board$/ do
end
###############################################################
Given /^i have not been added granted read access to the board$/ do
end
###############################################################
Given /^the board is not marked as public$/ do
end

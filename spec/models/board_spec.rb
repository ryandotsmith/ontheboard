require 'rubygems'
require 'facets/dictionary'
require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
["subject","board","user"].each do |f|
  require File.expand_path(File.dirname(__FILE__) + "/../factories/#{f}_factory")
end

describe Board do
  before(:each) do
    @valid_attributes = {
      :title => "value for title",
      :is_public => false
    }
  end

  it "should create a new instance given valid attributes" do
    Board.create!(@valid_attributes)
  end
end

describe "Creating a public board" do
  ###############
  before(:each) do
    @guest  = Factory( :user, :name => "Jim Whiteknuckle")
    @owner  = Factory( :user, :name => "Ron Arbuckle")
    @board  = Factory( :board, :user_id => @owner.id, :is_public => true) 
  end
  ###############

  it "should add the creating user as an owner of the board." do
    @owner.can(:write, @board).should eql( false )
    @board.allow!(@owner, :write)
    @owner.can(:write, @board).should eql( true )
  end
  
  it "should be findable based on owner object." do
    @owner.boards.include?(@board).should eql( true )
    @guest.boards.include?(@board).should eql( false )
  end
  
  it "should deny any other user write access to the board." do
    @guest.can(:write, @board).should eql( false )
  end
  
  it "should allow a guest to read the board" do
    @guest.can(:read, @board).should eql( true )
  end
  
  it "should allow a guest to execute something on the board" do
    @guest.can(:execute, @board).should eql( true )
  end
end

describe "Creating a private board" do
  ###############
  before(:each) do
    @guest  = Factory( :user, :name => "Jim Whiteknuckle")
    @owner  = Factory( :user, :name => "Ron Arbuckle")
    @board  = Factory( :board, :user_id => @owner.id, :is_public => false) 
  end
  ###############
  
  it "should add the creating user as an owner of the board." do
    @owner.can( :write, @board).should eql( false )
    @board.allow!( @owner, :write)
    @owner.can( :write , @board).should eql( true )
  end
  
  it "should be findable based on owner object." do
    @owner.boards.include?(@board).should eql( true )
    @guest.boards.include?(@board).should eql( false )
  end
  
  it "should deny any other user write access to the board." do
    @guest.can(:write, @board).should eql( false )
  end

  it "should deny any other user read access to the board." do
    @guest.can( :read, @board).should eql( false )
  end
  
  it "should deny any other user trying to execute an action on the board." do
    @guest.can(:execute, @board).should eql( false )
  end

end

describe "Giving a user new permission to a board" do
  ###############
  before(:each) do
    @unknown  = Factory( :user, :name => "Todd Billings")
    @guest    = Factory( :user, :name => "Jim Whiteknuckle")
    @owner    = Factory( :user, :name => "Ron Arbuckle")
    @board    = Factory( :board, :user_id => @owner.id, :is_public => false) 
  end
  ###############
  it "should add a user as a reader " do
    @guest.can( :read, @board).should eql( false )
    @board.allow!( @guest, :read)
    @guest.can( :read, @board).should eql( true )
  end

  it "should add a user as a subscriber " do
    @guest.can( :execute, @board).should eql( false )
    @board.allow!( @guest, :execute)
    @guest.can( :execute, @board).should eql( true )
  end

  it "should add a user as a owner " do
    @guest.can( :write, @board).should eql( false )
    @board.allow!( @guest, :write)
    @guest.can( :write, @board).should eql( true )
  end


end

describe "Change a user's permission on a board" do
  ###############
  before(:each) do
    @unknown  = Factory( :user, :name => "Todd Billings")
    @guest    = Factory( :user, :name => "Jim Whiteknuckle")
    @owner    = Factory( :user, :name => "Ron Arbuckle")
    
    @private_board    = Factory( :board, :user_id => @owner.id, :is_public => false) 
    @public_board     = Factory( :board, :user_id => @owner.id, :is_public => true) 
  end#before
  ###############


  it "should not change permissions for owner of board" do
    @private_board.make_owner!( @owner )
    @private_board.allow!( @owner, :read ).should eql( false )
  end

  describe "elevating permissions for readers" do
    before( :each ) do
      @guest.can( :read, @public_board).should eql( true )
      @guest.can( :read, @private_board).should eql( false  )
      @guest.can( :execute, @public_board ).should eql( true )
    end

    it "should make a reader a writer" do
      @guest.can( :execute, @private_board).should eql( false )
      @private_board.allow!( @guest, :execute)
      @guest.can( :execute, @private_board).should eql( true )
    end#it

    it "should make a reader an owner" do
      @guest.can( :write, @private_board).should eql( false )
      @private_board.allow!( @guest, :write)
      @guest.can( :write, @private_board).should eql( true )      
    end#it

  end#des
  
  describe "elevating permissions for subscribers" do
    before( :each ) do
      @private_board.allow!(@guest, :execute)
      @guest.can(:execute, @public_board).should eql( true )
      @guest.can(:execute, @private_board).should eql( true )
    end
    it "should give a subscriber write permissions " do
      @guest.can( :write, @private_board).should eql( false )
      @private_board.allow!( @guest, :write )
      @guest.can( :write, @private_board).should eql( true )
    end
  end
end#desc

describe "Get a list of users with permissions on a board" do
  ###############
  before(:each) do
    @unknown  = Factory( :user, :name => "Todd Billings")
    @guest    = Factory( :user, :name => "Jim Whiteknuckle")
    @owner    = Factory( :user, :name => "Ron Arbuckle")
    @board    = Factory( :board, :user_id => @owner.id, :is_public => false) 
  end
  ###############
  it "should return a hash of users and their permission levels " do
    @results = Dictionary.new
    @results[@owner.login.to_sym]   = [ "read", "execute","write" ]
    @results[@guest.login.to_sym]   = [ "read", "execute" ]
    @results[@unknown.login.to_sym] = [ "read" ]

    @board.allow!(   @owner,   :write  )  
    @board.allow!(   @guest,   :execute )
    @board.allow!(   @unknown, :read   )
    @board.list_permissions.should ==  @results 
 end
end

describe "Filtering parameters on update hooks" do
  # update_hooks is a method that i use to keep my updates restful
  # since i have multiple forms that will update a board in a variaty of 
  # ways, I call update_hooks in my controller and pass update_hooks the parameters hash
  before(:each) do
    @board  = Factory( :board )
    @params = { :board => @board }
  end
  
  it "should return a symbol describing the type of update preformed" do
    @params[:update_type] = :general
    @params[:board][:title] = "new_title"
    @board.update_hooks( @params ).should eql( :general )
  end

  it "should fail if the something went wrong" do
    @params[:update_type] = :this_is_not_a_type
    @board.update_hooks( @params ).should eql( :epoch_fail )
  end
  
end

describe "Finding users who have permissions on a board" do
  ###############
  before(:each) do
    @guest  = Factory( :user, :name => "Jim Whiteknuckle")
    @owner  = Factory( :user, :name => "Ron Arbuckle")
    @board  = Factory( :board, :user_id => @owner.id, :is_public => false) 
  end
  ###############
  it "should find one user" do
    #require 'rubygems'; require 'ruby-debug'; debugger;
    @board.users.length.should eql( 0 )
    #@board.allow!( @owner, :write).should eql( true )
    #@board.allow!( @guest, :write).should eql( true )
    #@board.users.length.should eql( 2 )
  end#it
end

describe "A board should have unique title w.r.t. the user" do
  before(:each) do
    @owner    = Factory( :user, :name => "Ron Arbuckle")
    @board    = Factory( :board, :user_id => @owner.id, :is_public => false, :title => "nifty") 
    @board1   = Factory( :board, :user_id => @owner.id, :is_public => false)
  end
  it "should return false if the user already has a board with given title" do
    @board1.title = "nifty"
    @board1.has_unique_title?.should eql( false )
  end
  it "should return true if the title is unique" do
    @board1.title = "real-nifty"
    @board1.has_unique_title?.should eql( true )    
  end
end

describe "changing the title of a board" do
  before(:each) do
    @owner    = Factory( :user, :name => "Ron Arbuckle")
    @other_u  = Factory( :user, :name => "Jim Jackson" )
    @board    = Factory( :board, :user_id => @owner.id, :is_public => false, :title => "nifty") 
    @board1   = Factory( :board, :user_id => @other_u.id, :is_public => false, :title => "nifty")
  end#before
  
  it "should not allow two boards with the same name under one user account" do
    @board1.title.should eql( "nifty")
    @board1.url.should eql( "nifty")
    #since this user already has a board named nifty, 
    # we should hope that the url that gets generated from another board named
    # nift will not be nift. In stead it should be something like nifty-1.
    #However, before a new board is created or updated, the title should be 
    # unique to the user. So theoretically this url business should never happen.
    # But, i tested for it anyways! 
    @board2 = Factory(:board, :user_id => @other_u.id, :title => 'nifty')
    @board2.url.should_not eql( "nifty")
  end
  
  it "should be ok with same board names under diff user accounts" do
    @board.url.should eql( 'nifty')
    # some random user should be able to create a board named "nifty"
    # whith the url named nifty since the scoping should take place at the user level. 
    @board3 = Factory( :board, :user_id => 998, :title => 'nifty')
    @board3.url.should eql( "nifty")
    
  end

  it "should update the url with the new title " do
    @board.title = "a new title"
    @board.save!
    @board.url.should eql( "a-new-title")
  end#it

end#des
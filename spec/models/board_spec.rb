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

describe "Giving a user permission to a board" do
  ###############
  before(:each) do
    @unknown  = Factory( :user, :name => "Todd Billings")
    @guest    = Factory( :user, :name => "Jim Whiteknuckle")
    @owner    = Factory( :user, :name => "Ron Arbuckle")
    @board    = Factory( :board, :user_id => @owner.id, :is_public => false) 
  end
  ###############
  it "should add a user as a subscriber " do
    @guest.can( :execute, @board).should eql( false )
    @board.allow!( @guest, :execute)
    @guest.can( :execute, @board).should eql( true )
  end
end

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
    @results[@owner.login.to_sym]   = [ "reader", "subscriber","owner" ]
    @results[@guest.login.to_sym]   = [ "reader", "subscriber" ]
    @results[@unknown.login.to_sym] = [ "reader" ]

    @board.allow!(   @owner,   :write  )  
    @board.allow!(   @guest,   :execute )
    @board.allow!(   @unknown, :read   )
    @board.list_permissions.should ==  @results 
 end
end



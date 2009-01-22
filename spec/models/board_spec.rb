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
    @board.is_writeable_by( @owner ).should eql( false )
    @board.make_owner!( @owner )
    @board.is_writeable_by( @owner ).should eql( true )
  end
  
  it "should be findable based on owner object." do
    @owner.boards.include?(@board).should eql( true )
    @guest.boards.include?(@board).should eql( false )
  end
  
  it "should deny any other user write access to the board." do
    @board.is_writeable_by( @guest ).should eql( false )
  end
  
  it "should allow a guest to read the board" do
    @board.is_readable_by( @guest ).should eql( true )
  end
  
  it "should allow a guest to execute something on the board" do
    @board.is_exec_by( @guest ).should eql( true )
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
    @board.is_writeable_by( @owner ).should eql( false )
    @board.make_owner!( @owner )
    @board.is_writeable_by( @owner ).should eql( true )
  end
  
  it "should be findable based on owner object." do
    @owner.boards.include?(@board).should eql( true )
    @guest.boards.include?(@board).should eql( false )
  end
  
  it "should deny any other user write access to the board." do
    @board.is_writeable_by( @guest ).should eql( false )
  end

  it "should deny any other user read access to the board." do
    @board.is_readable_by( @guest ).should eql( false )
  end
  
  it "should deny any other user trying to execute an action on the board." do
    @board.is_exec_by( @guest ).should eql( false )
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
    @guest.has_role?(  :subscriber, @board ).should eql( false )
    @board.is_exec_by( @guest ).should eql( false )
    @board.is_exec_by( @unknown ).should eql( false )
    #
    @board.make_subscriber!( @guest )
    #
    @guest.has_role?(  :subscriber, @board ).should eql( true )
    @board.is_exec_by( @guest ).should eql( true )
    @board.is_exec_by( @unknown ).should eql( false )
  end
end

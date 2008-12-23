require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require File.expand_path(File.dirname(__FILE__) + '/../factories/user_factory')
require File.expand_path(File.dirname(__FILE__) + '/../factories/board_factory')

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
  before(:each)do
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
  
  it "should deny any other user write access to the board." do
    @board.is_writeable_by( @guest ).should eql( false )
  end
  
  it "should allow a guest to read the board" do
    @board.is_readable_by( @guest ).should eql( true )
  end
end

describe "Creating a private board" do
  ###############
  before(:each)do
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
  
  it "should deny any other user write access to the board." do
    @board.is_writeable_by( @guest ).should eql( false )
  end

  it "should deny any other user read access to the board." do
    @board.is_readable_by( @guest ).should eql( false )
  end

end
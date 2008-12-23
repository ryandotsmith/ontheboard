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
  it "should add the creating user as an owner of the board." do
    user  = Factory( :user, :name => "Ron Arbuckle")
    board = Factory( :board, :user_id => user.id   ) 
    board.is_writeable_by( user ).should eql( false )
    board.make_owner!( user )
    board.is_writeable_by( user ).should eql( true )

  end
  
  it "should deny any other user write access to the board."
  
end

describe "Creating a private board" do

  it "should add the creating user as an owner of the board." 
  
  it "should deny any other user write access to the board."
  
end
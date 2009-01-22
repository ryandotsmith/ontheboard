require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

["subject","board","user"].each do |f|
  require File.expand_path(File.dirname(__FILE__) + "/../factories/#{f}_factory")
end


describe Subject do
  before(:each) do
    @valid_attributes = {
      :title => "value for title"
    }
  end

  it "should create a new instance given valid attributes" do
    Subject.create!(@valid_attributes)
  end
end

describe "Building a new subject on a board" do
  before(:each) do
    @board      =   Factory( :board ,:is_public => false  )
    @subject    =   Factory( :subject )
    @yas        =   Factory( :subject, :title => "haxor")
  end

  it "should be fairly easy" do
    @board.subjects << @subject
    @board.subjects.include?(@subject).should eql( true )
    @board.subjects.include?(@yas).should_not eql( true )
  end# end it
  
  it "should inherit the public status from it's board" do
    @board.subjects << @subject
    @subject.inherit_permissions!
    @subject.is_public.should eql( false )
  end
    

  
end# end describe

describe "Checking Permissions " do

  before(:each) do 
    @user       =   Factory( :user    )
    @board      =   Factory( :board   )
    @subject    =   Factory( :subject )
    @board.subjects << @subject
  end# before

  it "should allow anyone to write if board is public and subject is public" do
    @board.save! if @board.is_public = true
    @subject.inherit_permissions!
    @subject.is_exec_by( @user ).should eql( true )
  end# it

  it "should deny anyone to write if board is private and board is private" do
    @board.save! if @board.is_public = false
    @subject.inherit_permissions!
    @subject.is_exec_by( @user ).should eql( false )    
  end
  
  it "should allow user exec on subject if  user is subscriber when board & subject == private" do
    @board.save! if @board.is_public = false
    @subject.inherit_permissions!
    # before
    @subject.is_exec_by( @user ).should eql( false ) 
    #
    @subject.make_subscriber!( @user )
    # after
    @subject.is_exec_by( @user ).should eql( true )
  end
  
  it "should allow user to read board after user is made readable by subject on a board & subject private" do
    @board.save! if @board.is_public = false
    @subject.inherit_permissions!
    # before
    @subject.is_readable_by( @user ).should eql( false )
    #
    @subject.make_reader!( @user )
    #after
    @subject.is_readable_by( @user ).should eql( true )
  end
  
end# desc
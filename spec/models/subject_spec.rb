require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

["subject","board","user","tally"].each do |f|
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

describe "Checking Inherit Permissions " do

  before(:each) do 
    @user       =   Factory( :user    )
    @board      =   Factory( :board   )
    @subject    =   Factory( :subject )
    @board.subjects << @subject
  end# before

  it "should inherit permissions and allow board reader" do
    @board.save! if @board.is_public = true
    @subject.inherit_permissions! and @subject.inherits.should eql( true )
    @user.can(:read, @board).should eql( true )
    @user.can(:read, @subject).should eql( true )
    @user.can(:execute, @subject).should eql( true )
    @user.can(:write,@subject).should eql( false)
  end# it

  it "should inherit permissions and deny a board reader" do
    @board.save! if @board.is_public = false
    @subject.inherit_permissions! and @subject.inherits.should eql( true )
    @user.can(:read, @board).should eql( false )
    @subject.allow!( @user, :read )
    @user.can(:read, @subject).should eql( true )
  end
  
  it "should give the user exec access to subject if the board says user is subscriber" do
    @board.save! if @board.is_public = false
    @subject.inherit_permissions! and @subject.inherits.should eql( true )
    
    @user.can(:read, @board).should eql( false )
    @user.can(:execute, @board).should eql( false )
    @user.can(:write, @board).should eql( false )

    @user.can(:read, @subject).should eql( false )
    @user.can(:execute, @subject).should eql( false )
    @user.can(:write, @subject).should eql( false )

    @board.allow!( @user, :execute) and @board.accepts_role?( :subscriber, @user).should eql( true )

    @user.can(:read, @board).should eql( true )
    @user.can(:execute, @board).should eql( true )
    @user.can(:write, @board).should eql( false )
    
    @user.can(:read, @subject).should eql( true )
    @user.can(:execute, @subject).should eql( true )
    @user.can(:write, @subject).should eql( false )
    
  end

  it "should give user write access to subject if the board says that user is owner" do
    @board.save! if @board.is_public = false
    @subject.inherit_permissions! and @subject.inherits.should eql( true )
    
    @user.can(:read, @board).should eql( false )
    @user.can(:execute, @board).should eql( false )
    @user.can(:write, @board).should eql( false )

    @user.can(:read, @subject).should eql( false )
    @user.can(:execute, @subject).should eql( false )
    @user.can(:write, @subject).should eql( false )

    @board.allow!( @user, :write) and @board.accepts_role?( :owner, @user).should eql( true )

    @user.can(:read, @board).should eql( true )
    @user.can(:execute, @board).should eql( true )
    @user.can(:write, @board).should eql( true )
    
    @user.can(:read, @subject).should eql( true )
    @user.can(:execute, @subject).should eql( true )
    @user.can(:write, @subject).should eql( true )
    

  end

  describe "Overriding board permissions for a subject" do

    it "should reset inheritance on a subject when permissions are set local" do
      @board.save! if @board.is_public = false
      @subject.inherit_permissions! and @subject.inherits.should eql( true )    
      @subject.allow!( @user, :read )
      @subject.inherits.should eql( false )
    end
    
    it " board[write] -> subject[read]" do

      @board.save! if @board.is_public = false
      @subject.inherit_permissions! and @subject.inherits.should eql( true )    
      @board.allow!( @user, :write)
      @user.can(:write, @board).should eql( true )
      @user.can(:write, @subject).should eql( true )
      @subject.allow!( @user, :read)
      @user.can(:write, @board).should eql( true )
      @user.can(:write, @subject).should eql( false )
      @user.can(:read, @subject).should eql( true )
      
    end
  
    it " board[execute] -> subject[read] " do
      @board.save! if @board.is_public = false
      @subject.inherit_permissions! and @subject.inherits.should eql( true )    
      @board.allow!( @user, :execute )
      @user.can(:execute, @board).should eql( true )
      @user.can(:execute, @subject).should eql( true )
      @subject.allow!( @user, :read)
      @user.can(:execute, @board).should eql( true )
      @user.can(:execute, @subject).should eql( false )
      @user.can(:read, @subject).should eql( true )
      
    end
    
    it " board[read] -> subject[read] " do
      @board.save! if @board.is_public = false
      @subject.inherit_permissions! and @subject.inherits.should eql( true )    

      @board.allow!( @user, :read )

      @user.can(:read, @board).should eql( true )
      @user.can(:read, @subject).should eql( true )

      @subject.allow!( @user, :read)

      @user.can(:read, @board).should eql( true )
      @user.can(:read, @subject).should eql( true )
      
    end
    
    it " board[write] -> subject[execute]" do
      
    end
    
    it "board[execute] -> subject[execute]" do
      
    end

    it "board[read] -> subject[execute]" do
      
    end
  end#desc

end# desc

describe "Authorizing a user to act on subject" do

  before(:each) do 
    @user       =   Factory( :user    )
    @board      =   Factory( :board   )
    @subject    =   Factory( :subject )
    @board.subjects << @subject
  end#before


  it "should first see if the board is public" do
    @subject.is_public = true and @subject.is_public.should eql( true )
    @subject.inherits  = false and @board.inherits.should eql( false )
    @subject.authorize( @user, :read ).should eql( true )
    @subject.authorize( @user, :execute).should eql( true )
    @subject.authorize( @user, :write).should eql( false )
  end#it


end#des

describe "getting users who have tallied on subject" do
  
  before(:each) do 
    @user_0     =   Factory( :user, :id => 12, :login => "whatman"    )
    @user_1     =   Factory( :user, :id => 14, :login => "whoman", :email => "who@gmail.com")
    @board      =   Factory( :board   )
    @subject    =   Factory( :subject )
    @board.subjects << @subject
    @t1         =   Factory( :tally, :user_id => 12 )
    @t2         =   Factory( :tally, :user_id => 12 )
    @t3         =   Factory( :tally, :user_id => 14 )
    @subject.tallies << @t1
    @subject.tallies << @t2
    @subject.tallies << @t3
  end#before
  
  it "should return hash with user login as key and tally count as value" do
    @subject.get_tallies_with_users.should == {:whatman => 2, :whoman => 1}
  end#it
end#des

describe "overidding " do
  
end



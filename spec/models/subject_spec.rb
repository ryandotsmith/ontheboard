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
    @board      =   Factory( :board   )
    @subject    =   Factory( :subject )
    @yas        =   Factory( :subject, :title => "haxor")
  end

  it "should be fairly easy" do
    @board.subjects << @subject
    @board.subjects.include?(@subject).should eql( true )
    @board.subjects.include?(@yas).should_not eql( true )
  end# end it

end# end describe

describe "Find a subject from parameters" do
  it "should return a subject " do
    @user       =   Factory( :user, :name=>"ryandotsmith", :id => 1    )
    @board      =   Factory( :board, :url => 'sales'   )
    @subject    =   Factory( :subject, :title => 'brokered-loads' )
    
    @parameters = { "subject_name"=>"brokered-loads",
                    "board_url"   =>"sales",
                    "user_name"   =>"ryandotsmith"}
    Subject.find_from( @parameters ).should eql( @subject )
  end
end
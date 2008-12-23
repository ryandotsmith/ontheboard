require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

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

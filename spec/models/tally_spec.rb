require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Tally do
  before(:each) do
    @valid_attributes = {
      :int_val => "1",
      :str_val => "value for str_val",
      :text_val => "value for text_val",
      :bool_val => false,
      :user_id => "1"
    }
  end

  it "should create a new instance given valid attributes" do
    Tally.create!(@valid_attributes)
  end
end

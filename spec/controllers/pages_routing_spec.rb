require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe PagesController do

  describe "route generation" do
    it "should map #show" do
      route_for(  :controller => "pages", 
                  :action => "show", 
                  :user_name => "ronarbuckle").should == "/ronarbuckle"
    end
  end
  
  describe "route recognition" do
    it "should generate params for #show" do
      params_from(:get, "/ronarbuckle").should == {
                                                    :controller => "pages", 
                                                    :action     => "show", 
                                                    :user_name  => "ronarbuckle"}
    end
  end

end

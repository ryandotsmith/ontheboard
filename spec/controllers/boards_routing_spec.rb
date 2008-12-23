require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe BoardsController do
  describe "route generation" do
    it "should map #index" do
      route_for(:controller => "boards", :action => "index").should == "/boards"
    end
  
    it "should map #new" do
      route_for(:controller => "boards", :action => "new").should == "/boards/new"
    end
  
    it "should map #show" do
      route_for(:controller => "boards", :action => "show", :id => 1).should == "/boards/1"
    end
  
    it "should map #edit" do
      route_for(:controller => "boards", :action => "edit", :id => 1).should == "/boards/1/edit"
    end
  
    it "should map #update" do
      route_for(:controller => "boards", :action => "update", :id => 1).should == "/boards/1"
    end
  
    it "should map #destroy" do
      route_for(:controller => "boards", :action => "destroy", :id => 1).should == "/boards/1"
    end
  end

  describe "route recognition" do
    it "should generate params for #index" do
      params_from(:get, "/boards").should == {:controller => "boards", :action => "index"}
    end
  
    it "should generate params for #new" do
      params_from(:get, "/boards/new").should == {:controller => "boards", :action => "new"}
    end
  
    it "should generate params for #create" do
      params_from(:post, "/boards").should == {:controller => "boards", :action => "create"}
    end
  
    it "should generate params for #show" do
      params_from(:get, "/boards/1").should == {:controller => "boards", :action => "show", :id => "1"}
    end
  
    it "should generate params for #edit" do
      params_from(:get, "/boards/1/edit").should == {:controller => "boards", :action => "edit", :id => "1"}
    end
  
    it "should generate params for #update" do
      params_from(:put, "/boards/1").should == {:controller => "boards", :action => "update", :id => "1"}
    end
  
    it "should generate params for #destroy" do
      params_from(:delete, "/boards/1").should == {:controller => "boards", :action => "destroy", :id => "1"}
    end
  end
end

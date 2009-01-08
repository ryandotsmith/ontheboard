require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe SubjectsController do
  describe "route generation" do
    it "should map #index" do
      route_for(:controller => "subjects", :action => "index").should == "/subjects"
    end
  
    it "should map #new" do
      route_for(:controller => "subjects", :action => "new").should == "/subjects/new"
    end
  
    it "should map #show" do
      route_for(:controller => "subjects", :action => "show", :id => 1).should == "/subjects/1"
    end
  
    it "should map #edit" do
      route_for(:controller => "subjects", :action => "edit", :id => 1).should == "/subjects/1/edit"
    end
  
    it "should map #update" do
      route_for(:controller => "subjects", :action => "update", :id => 1).should == "/subjects/1"
    end
  
    it "should map #destroy" do
      route_for(:controller => "subjects", :action => "destroy", :id => 1).should == "/subjects/1"
    end
  end

  describe "route recognition" do
    it "should generate params for #index" do
      params_from(:get, "/subjects").should == {:controller => "subjects", :action => "index"}
    end
  
    it "should generate params for #new" do
      params_from(:get, "/subjects/new").should == {:controller => "subjects", :action => "new"}
    end
  
    it "should generate params for #create" do
      params_from(:post, "/subjects").should == {:controller => "subjects", :action => "create"}
    end
  
    it "should generate params for #show" do
      params_from(:get, "/subjects/1").should == {:controller => "subjects", :action => "show", :id => "1"}
    end
  
    it "should generate params for #edit" do
      params_from(:get, "/subjects/1/edit").should == {:controller => "subjects", :action => "edit", :id => "1"}
    end
  
    it "should generate params for #update" do
      params_from(:put, "/subjects/1").should == {:controller => "subjects", :action => "update", :id => "1"}
    end
  
    it "should generate params for #destroy" do
      params_from(:delete, "/subjects/1").should == {:controller => "subjects", :action => "destroy", :id => "1"}
    end
  end
end

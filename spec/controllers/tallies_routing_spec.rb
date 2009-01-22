=begin
require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe TalliesController do
  describe "route generation" do
    it "should map #index" do
      route_for(:controller => "tallies", :action => "index").should == "/tallies"
    end
  
    it "should map #new" do
      route_for(:controller => "tallies", :action => "new").should == "/tallies/new"
    end
  
    it "should map #show" do
      route_for(:controller => "tallies", :action => "show", :id => 1).should == "/tallies/1"
    end
  
    it "should map #edit" do
      route_for(:controller => "tallies", :action => "edit", :id => 1).should == "/tallies/1/edit"
    end
  
    it "should map #update" do
      route_for(:controller => "tallies", :action => "update", :id => 1).should == "/tallies/1"
    end
  
    it "should map #destroy" do
      route_for(:controller => "tallies", :action => "destroy", :id => 1).should == "/tallies/1"
    end
  end

  describe "route recognition" do
    it "should generate params for #index" do
      params_from(:get, "/tallies").should == {:controller => "tallies", :action => "index"}
    end
  
    it "should generate params for #new" do
      params_from(:get, "/tallies/new").should == {:controller => "tallies", :action => "new"}
    end
  
    it "should generate params for #create" do
      params_from(:post, "/tallies").should == {:controller => "tallies", :action => "create"}
    end
  
    it "should generate params for #show" do
      params_from(:get, "/tallies/1").should == {:controller => "tallies", :action => "show", :id => "1"}
    end
  
    it "should generate params for #edit" do
      params_from(:get, "/tallies/1/edit").should == {:controller => "tallies", :action => "edit", :id => "1"}
    end
  
    it "should generate params for #update" do
      params_from(:put, "/tallies/1").should == {:controller => "tallies", :action => "update", :id => "1"}
    end
  
    it "should generate params for #destroy" do
      params_from(:delete, "/tallies/1").should == {:controller => "tallies", :action => "destroy", :id => "1"}
    end
  end
end
=end
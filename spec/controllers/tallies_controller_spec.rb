require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe TalliesController do

  def mock_tally(stubs={})
    @mock_tally ||= mock_model(Tally, stubs)
  end
=begin  
  describe "responding to GET index" do

    it "should expose all tallies as @tallies" do
      Tally.should_receive(:find).with(:all).and_return([mock_tally])
      get :index
      assigns[:tallies].should == [mock_tally]
    end

    describe "with mime type of xml" do
  
      it "should render all tallies as xml" do
        request.env["HTTP_ACCEPT"] = "application/xml"
        Tally.should_receive(:find).with(:all).and_return(tallies = mock("Array of Tallies"))
        tallies.should_receive(:to_xml).and_return("generated XML")
        get :index
        response.body.should == "generated XML"
      end
    
    end

  end

  describe "responding to GET show" do

    it "should expose the requested tally as @tally" do
      Tally.should_receive(:find).with("37").and_return(mock_tally)
      get :show, :id => "37"
      assigns[:tally].should equal(mock_tally)
    end
    
    describe "with mime type of xml" do

      it "should render the requested tally as xml" do
        request.env["HTTP_ACCEPT"] = "application/xml"
        Tally.should_receive(:find).with("37").and_return(mock_tally)
        mock_tally.should_receive(:to_xml).and_return("generated XML")
        get :show, :id => "37"
        response.body.should == "generated XML"
      end

    end
    
  end

  describe "responding to GET new" do
  
    it "should expose a new tally as @tally" do
      Tally.should_receive(:new).and_return(mock_tally)
      get :new
      assigns[:tally].should equal(mock_tally)
    end

  end

  describe "responding to GET edit" do
  
    it "should expose the requested tally as @tally" do
      Tally.should_receive(:find).with("37").and_return(mock_tally)
      get :edit, :id => "37"
      assigns[:tally].should equal(mock_tally)
    end

  end

  describe "responding to POST create" do

    describe "with valid params" do
      
      it "should expose a newly created tally as @tally" do
        Tally.should_receive(:new).with({'these' => 'params'}).and_return(mock_tally(:save => true))
        post :create, :tally => {:these => 'params'}
        assigns(:tally).should equal(mock_tally)
      end

      it "should redirect to the created tally" do
        Tally.stub!(:new).and_return(mock_tally(:save => true))
        post :create, :tally => {}
        response.should redirect_to(tally_url(mock_tally))
      end
      
    end
    
    describe "with invalid params" do

      it "should expose a newly created but unsaved tally as @tally" do
        Tally.stub!(:new).with({'these' => 'params'}).and_return(mock_tally(:save => false))
        post :create, :tally => {:these => 'params'}
        assigns(:tally).should equal(mock_tally)
      end

      it "should re-render the 'new' template" do
        Tally.stub!(:new).and_return(mock_tally(:save => false))
        post :create, :tally => {}
        response.should render_template('new')
      end
      
    end
    
  end

  describe "responding to PUT udpate" do

    describe "with valid params" do

      it "should update the requested tally" do
        Tally.should_receive(:find).with("37").and_return(mock_tally)
        mock_tally.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :tally => {:these => 'params'}
      end

      it "should expose the requested tally as @tally" do
        Tally.stub!(:find).and_return(mock_tally(:update_attributes => true))
        put :update, :id => "1"
        assigns(:tally).should equal(mock_tally)
      end

      it "should redirect to the tally" do
        Tally.stub!(:find).and_return(mock_tally(:update_attributes => true))
        put :update, :id => "1"
        response.should redirect_to(tally_url(mock_tally))
      end

    end
    
    describe "with invalid params" do

      it "should update the requested tally" do
        Tally.should_receive(:find).with("37").and_return(mock_tally)
        mock_tally.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :tally => {:these => 'params'}
      end

      it "should expose the tally as @tally" do
        Tally.stub!(:find).and_return(mock_tally(:update_attributes => false))
        put :update, :id => "1"
        assigns(:tally).should equal(mock_tally)
      end

      it "should re-render the 'edit' template" do
        Tally.stub!(:find).and_return(mock_tally(:update_attributes => false))
        put :update, :id => "1"
        response.should render_template('edit')
      end

    end

  end

  describe "responding to DELETE destroy" do

    it "should destroy the requested tally" do
      Tally.should_receive(:find).with("37").and_return(mock_tally)
      mock_tally.should_receive(:destroy)
      delete :destroy, :id => "37"
    end
  
    it "should redirect to the tallies list" do
      Tally.stub!(:find).and_return(mock_tally(:destroy => true))
      delete :destroy, :id => "1"
      response.should redirect_to(tallies_url)
    end

  end
=end
end

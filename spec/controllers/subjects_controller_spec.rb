require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe SubjectsController do

  def mock_subject(stubs={})
    @mock_subject ||= mock_model(Subject, stubs)
  end
  
  describe "responding to GET index" do

    it "should expose all subjects as @subjects" do
      Subject.should_receive(:find).with(:all).and_return([mock_subject])
      get :index
      assigns[:subjects].should == [mock_subject]
    end

    describe "with mime type of xml" do
  
      it "should render all subjects as xml" do
        request.env["HTTP_ACCEPT"] = "application/xml"
        Subject.should_receive(:find).with(:all).and_return(subjects = mock("Array of Subjects"))
        subjects.should_receive(:to_xml).and_return("generated XML")
        get :index
        response.body.should == "generated XML"
      end
    
    end

  end

  describe "responding to GET show" do

    it "should expose the requested subject as @subject" do
      Subject.should_receive(:find).with("37").and_return(mock_subject)
      get :show, :id => "37"
      assigns[:subject].should equal(mock_subject)
    end
    
    describe "with mime type of xml" do

      it "should render the requested subject as xml" do
        request.env["HTTP_ACCEPT"] = "application/xml"
        Subject.should_receive(:find).with("37").and_return(mock_subject)
        mock_subject.should_receive(:to_xml).and_return("generated XML")
        get :show, :id => "37"
        response.body.should == "generated XML"
      end

    end
    
  end

  describe "responding to GET new" do
  
    it "should expose a new subject as @subject" do
      Subject.should_receive(:new).and_return(mock_subject)
      get :new
      assigns[:subject].should equal(mock_subject)
    end

  end

  describe "responding to GET edit" do
  
    it "should expose the requested subject as @subject" do
      Subject.should_receive(:find).with("37").and_return(mock_subject)
      get :edit, :id => "37"
      assigns[:subject].should equal(mock_subject)
    end

  end

  describe "responding to POST create" do

    describe "with valid params" do
      
      it "should expose a newly created subject as @subject" do
        Subject.should_receive(:new).with({'these' => 'params'}).and_return(mock_subject(:save => true))
        post :create, :subject => {:these => 'params'}
        assigns(:subject).should equal(mock_subject)
      end

      it "should redirect to the created subject" do
        Subject.stub!(:new).and_return(mock_subject(:save => true))
        post :create, :subject => {}
        response.should redirect_to(subject_url(mock_subject))
      end
      
    end
    
    describe "with invalid params" do

      it "should expose a newly created but unsaved subject as @subject" do
        Subject.stub!(:new).with({'these' => 'params'}).and_return(mock_subject(:save => false))
        post :create, :subject => {:these => 'params'}
        assigns(:subject).should equal(mock_subject)
      end

      it "should re-render the 'new' template" do
        Subject.stub!(:new).and_return(mock_subject(:save => false))
        post :create, :subject => {}
        response.should render_template('new')
      end
      
    end
    
  end

  describe "responding to PUT udpate" do

    describe "with valid params" do

      it "should update the requested subject" do
        Subject.should_receive(:find).with("37").and_return(mock_subject)
        mock_subject.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :subject => {:these => 'params'}
      end

      it "should expose the requested subject as @subject" do
        Subject.stub!(:find).and_return(mock_subject(:update_attributes => true))
        put :update, :id => "1"
        assigns(:subject).should equal(mock_subject)
      end

      it "should redirect to the subject" do
        Subject.stub!(:find).and_return(mock_subject(:update_attributes => true))
        put :update, :id => "1"
        response.should redirect_to(subject_url(mock_subject))
      end

    end
    
    describe "with invalid params" do

      it "should update the requested subject" do
        Subject.should_receive(:find).with("37").and_return(mock_subject)
        mock_subject.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :subject => {:these => 'params'}
      end

      it "should expose the subject as @subject" do
        Subject.stub!(:find).and_return(mock_subject(:update_attributes => false))
        put :update, :id => "1"
        assigns(:subject).should equal(mock_subject)
      end

      it "should re-render the 'edit' template" do
        Subject.stub!(:find).and_return(mock_subject(:update_attributes => false))
        put :update, :id => "1"
        response.should render_template('edit')
      end

    end

  end

  describe "responding to DELETE destroy" do

    it "should destroy the requested subject" do
      Subject.should_receive(:find).with("37").and_return(mock_subject)
      mock_subject.should_receive(:destroy)
      delete :destroy, :id => "37"
    end
  
    it "should redirect to the subjects list" do
      Subject.stub!(:find).and_return(mock_subject(:destroy => true))
      delete :destroy, :id => "1"
      response.should redirect_to(subjects_url)
    end

  end

end

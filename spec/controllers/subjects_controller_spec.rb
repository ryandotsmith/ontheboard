require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe SubjectsController do
  before(:each) do 
    def mock_subject(stubs={})
      @mock_subject ||= mock_model(Subject, stubs)
    end
    def mock_board(stubs={:id => 1,:user_id => 1,:url => "eats-fish",:title => "eats-fish"})
      @mock_board ||= mock_model(Board,stubs)
    end
    @board    =   mock_board
    @subject  =   mock_subject
    
    end
    
=begin  
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
=end

  describe "responding to GET new" do
  
    before(:each) do 
      def get_params( action )
          @params = { "action"     => "#{ action }",
                      "board_url"  => "eats-fish",
                      "controller" => "subjects",
                      "user_name"  => "ryan" }

      end
    end
    it "should expose a new subject as @subject" do
      parameter = "eats-fish"
      @params = get_params( "new" )
      Board.should_receive(:find_from).exactly(1).times.with(@params).and_return(@board)
      @board.should_receive(:subjects).and_return(@subject)
      @subject.should_receive(:build).and_return( @subject)
      get :new, :user_name => "ryan", :board_url => "eats-fish"
      assigns[:subject].should equal(mock_subject)
    end

  end

  describe "responding to GET edit" do
    before(:each) do
      def get_params( action )
          @params = { "action"     => "#{ action }",
                      "board_url"  => "eats-fish",
                      "controller" => "subjects",
                      "user_name"  => "ryan",
                      "subject_name" => "red-fish" }

      end#end method
    end# end before
    it "should expose the requested subject as @subject" do
      @params = get_params( 'edit' )
      Subject.should_receive(:find_from).with(@params).and_return(mock_subject)
      Board.should_receive(:find_from).exactly(1).times.with(@params).and_return(@board)
      get :edit, :user_name => 'ryan', :board_url => 'eats-fish', :subject_name => 'red-fish'
      assigns[:subject].should equal(mock_subject)
    end

  end

  describe "responding to POST create" do
    before(:each) do 
      @board.should_receive(:subjects).and_return(@subject)
      @subject.should_receive(:build).and_return( @subject) 
      def get_params( action )
        @params = { "action"     => "#{ action }",
                    "subject"    => {"these" => "params"},
                    "board_url"  => "eats-fish",
                    "controller" => "subjects",
                    "user_name"  => "ryan" }
      end#end method
    end# end before     
    describe "with valid params" do
      
      it "should expose a newly created subject as @subject and does not inherti" do
        @user     = mock_model User
        @params   = get_params( "create" )
        Board.should_receive(:find_from).exactly(1).times.with(@params).and_return(@board)
        @board.should_receive(:user).and_return( @user )
        @user.should_receive(:login).and_return( 'ryan' )
        @board.should_receive(:url).and_return( 'eats-fish' )
        @subject.should_receive(:inherits).and_return( false )
        @subject.should_receive(:allow!).and_return( true )
        @subject.should_receive(:save).and_return( true )
        post :create, :subject => {:these => 'params'},:user_name => "ryan", :board_url => "eats-fish"
        assigns(:subject).should equal(mock_subject)
      end

      it "should redirect to the created subject and does not inherti" do
        @user     = mock_model User
        @params   = get_params( "create" )
        Board.should_receive(:find_from).exactly(1).times.with(@params).and_return(@board)
        @board.should_receive(:user).and_return( @user )
        @user.should_receive(:login).and_return( 'ryan' )
        @board.should_receive(:url).and_return( 'eats-fish' )
        @subject.should_receive(:inherits).and_return( false )
        @subject.should_receive(:allow!).and_return( true )
        @subject.should_receive(:save).and_return( true )  
        post :create, :subject => {:these => 'params'},:user_name => "ryan", :board_url => "eats-fish"
        response.should redirect_to(user_board_url)
      end
      
      it "should expose a newly created subject as @subject and does inherti" do
        @user     = mock_model User
        @params   = get_params( "create" )
        Board.should_receive(:find_from).exactly(1).times.with(@params).and_return(@board)
        @board.should_receive(:user).and_return( @user )
        @user.should_receive(:login).and_return( 'ryan' )
        @board.should_receive(:url).and_return( 'eats-fish' )
        @subject.should_receive(:inherits).and_return( true )
        @subject.should_receive(:save).and_return( true )
        post :create, :subject => {:these => 'params'},:user_name => "ryan", :board_url => "eats-fish"
        assigns(:subject).should equal(mock_subject)
      end

      it "should redirect to the created subject and does inherti" do
        @user     = mock_model User
        @params   = get_params( "create" )
        Board.should_receive(:find_from).exactly(1).times.with(@params).and_return(@board)
        @board.should_receive(:user).and_return( @user )
        @user.should_receive(:login).and_return( 'ryan' )
        @board.should_receive(:url).and_return( 'eats-fish' )
        @subject.should_receive(:inherits).and_return( true )
        @subject.should_receive(:save).and_return( true )  
        post :create, :subject => {:these => 'params'},:user_name => "ryan", :board_url => "eats-fish"
        response.should redirect_to(user_board_url)
      end
      
      
    end
    
    describe "with invalid params" do

      it "should expose a newly created but unsaved subject as @subject" do
        @user     = mock_model User
        @params   = get_params( "create" )
        Board.should_receive(:find_from).exactly(1).times.with(@params).and_return(@board)

        @subject.should_receive(:save).and_return( false )
        post :create, :subject => {:these => 'params'},:user_name => "ryan", :board_url => "eats-fish"
        assigns(:subject).should equal(mock_subject)
      end

      it "should re-render the 'new' template" do
        @user     = mock_model User
        @params   = get_params( "create" )
        Board.should_receive(:find_from).exactly(1).times.with(@params).and_return(@board)

        @subject.should_receive(:save).and_return( false )
        post :create, :subject => {:these => 'params'},:user_name => "ryan", :board_url => "eats-fish"
        response.should render_template('new')
      end#end it 
    end#end describe 
    
  end#end describe 

  describe "responding to PUT udpate" do
    before(:each) do 
      def get_params( action )
        @params = { "action"     => "#{ action }",
                    "subject"    => {"these" => "params"},
                    "board_url"  => "eats-fish",
                    "controller" => "subjects",
                    "subject_name" => "red-fish",
                    "user_name"  => "ryan" }
      end#end method
    end#end before
    describe "with valid params" do

      it "should update the requested subject" do
       # Subject.should_receive(:find).with("37").and_return( @subject )
        @user     = mock_model User
        @params   = get_params( "update" )
        Board.should_receive(:find_from).exactly(1).times.with(@params).and_return(@board)

        Subject.should_receive(:find_from).and_return( @subject )
        @subject.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :user_name => 'ryan', :board_url => 'eats-fish',:subject_name => 'red-fish', :subject => {:these => 'params'}
      end

      it "should expose the requested subject as @subject" do
        @user     = mock_model User
        @params   = get_params( "update" )
        Board.should_receive(:find_from).exactly(1).times.with(@params).and_return(@board)
        @board.should_receive(:user).and_return( @user )
        @user.should_receive(:login).and_return( 'ryan' )
        @board.should_receive(:url).and_return( 'eats-fish' )

        Subject.should_receive(:find_from).with(@params).and_return(@subject)
        @subject.should_receive(:update_attributes).and_return( true )
        put :update, :user_name => 'ryan', :board_url => 'eats-fish',:subject_name => 'red-fish', :subject => {:these => 'params'}
        assigns(:subject).should equal( @subject )
      end

      it "should redirect to the board" do
        @user     = mock_model User
        @params   = get_params( "update" )
        Board.should_receive(:find_from).exactly(2).times.with(@params).and_return(@board)
        @board.should_receive(:user).and_return( @user )
        @user.should_receive(:login).and_return( 'ryan' )
        @board.should_receive(:url).and_return( 'eats-fish' )

        @subject = mock_model(Subject, {:update_attributes => true })
        Subject.stub!(:find).and_return( @subject )
        put :update ,:user_name => "ryan", :board_url => "eats-fish", :subject_name => 'red-fish', :subject => {:these => 'params'}

        response.should redirect_to(user_board_url)
      end

    end
    
    describe "with invalid params" do

      it "should update the requested subject" do
        @user     = mock_model User
        @params   = get_params( "update" )
        Board.should_receive(:find_from).exactly(1).times.with(@params).and_return(@board)

        Subject.should_receive(:find_from).and_return( @subject )
        @subject.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :user_name => 'ryan', :board_url => 'eats-fish',:subject_name => 'red-fish', :subject => {:these => 'params'}
      end

      it "should expose the subject as @subject" do
        @user     = mock_model User
        @params   = get_params( "update" )
        Board.should_receive(:find_from).exactly(1).times.with(@params).and_return(@board)

        Subject.should_receive(:find_from).with(@params).and_return(@subject)
        @subject.should_receive(:update_attributes).and_return( false )
        put :update, :user_name => 'ryan', :board_url => 'eats-fish',:subject_name => 'red-fish', :subject => {:these => 'params'}
        assigns(:subject).should equal( @subject )
      end

      it "should re-render the 'edit' template" do
        @user     = mock_model User
        @params   = get_params( "update" )
        Board.should_receive(:find_from).exactly(1).times.with(@params).and_return(@board)

        Subject.should_receive(:find_from).with(@params).and_return(@subject)
        @subject.should_receive(:update_attributes).and_return( false )
        put :update, :user_name => 'ryan', :board_url => 'eats-fish',:subject_name => 'red-fish', :subject => {:these => 'params'}
        response.should render_template('edit')
      end

    end

  end

  describe "responding to DELETE destroy" do
    before(:each) do 
      def get_params( action )
         @params = { "action"     => "#{ action }",
                     "board_url"  => "eats-fish",
                     "controller" => "subjects",
                     "user_name"  => "ryan",
                     "subject_name" => "red-fish" }
       end#end method
       @user     = mock_model User
       @params   = get_params( "destroy" )
       Board.should_receive(:find_from).exactly(1).times.with(@params).and_return(@board)
       @board.should_receive(:user).and_return( @user )
       @user.should_receive(:login).and_return( 'ryan' )
       @board.should_receive(:url).and_return( 'eats-fish' )
       
    end
    it "should destroy the requested subject" do
      Subject.should_receive(:find_from).with(@params).and_return( @subject )
      @subject.should_receive(:destroy)
      delete :destroy, :user_name => "ryan", :board_url => "eats-fish", :subject_name => 'red-fish'
    end
  
    it "should redirect to the subjects list" do
      Subject.should_receive(:find_from).with(@params).and_return( @subject )
      @subject.should_receive(:destroy).and_return( true )
      delete :destroy, :user_name => "ryan", :board_url => "eats-fish", :subject_name => 'red-fish'
      response.should redirect_to(user_board_url)
    end

  end

end



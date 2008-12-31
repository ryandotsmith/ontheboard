
require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe BoardsController do

  def mock_board(stubs={})
    @mock_board ||= mock_model(Board, stubs)
  end
=begin
  describe "responding to GET index" do

    it "should expose all boards as @boards" do
      Board.should_receive(:find).with(:all).and_return([mock_board])
      get :index
      assigns[:boards].should == [mock_board]
    end

    describe "with mime type of xml" do
  
      it "should render all boards as xml" do
        request.env["HTTP_ACCEPT"] = "application/xml"
        Board.should_receive(:find).with(:all).and_return(boards = mock("Array of Boards"))
        boards.should_receive(:to_xml).and_return("generated XML")
        get :index
        response.body.should == "generated XML"
      end
    
    end

  end
=end
  describe "responding to GET show" do

    it "should expose the requested board as @board" do
      Board.should_receive(:find).with("37").and_return( mock_board )
      get :show, :id => "37"
      assigns[:board].should equal( mock_board )
    end
    
    describe "with mime type of xml" do

      it "should render the requested board as xml" do
        request.env["HTTP_ACCEPT"] = "application/xml"
        Board.should_receive(:find).with("37").and_return(mock_board)
        mock_board.should_receive(:to_xml).and_return("generated XML")
        get :show, :id => "37"
        response.body.should == "generated XML"
      end

    end
    
  end
=begin
  describe "responding to GET new" do
  
    it "should expose a new board as @board" do
      Board.should_receive(:new).and_return(mock_board)
      get :new
      assigns[:board].should equal(mock_board)
    end

  end

  describe "responding to GET edit" do
  
    it "should expose the requested board as @board" do
      Board.should_receive(:find).with("37").and_return(mock_board)
      get :edit, :id => "37"
      assigns[:board].should equal(mock_board)
    end

  end

  describe "responding to POST create" do

    describe "with valid params" do
      
      it "should expose a newly created board as @board" do
        Board.should_receive(:new).with({'these' => 'params'}).and_return(mock_board(:save => true))
        post :create, :board => {:these => 'params'}
        assigns(:board).should equal(mock_board)
      end

      it "should redirect to the created board" do
        Board.stub!(:new).and_return(mock_board(:save => true))
        post :create, :board => {}
        response.should redirect_to(board_url(mock_board))
      end
      
    end
    
    describe "with invalid params" do

      it "should expose a newly created but unsaved board as @board" do
        Board.stub!(:new).with({'these' => 'params'}).and_return(mock_board(:save => false))
        post :create, :board => {:these => 'params'}
        assigns(:board).should equal(mock_board)
      end

      it "should re-render the 'new' template" do
        Board.stub!(:new).and_return(mock_board(:save => false))
        post :create, :board => {}
        response.should render_template('new')
      end
      
    end
    
  end

  describe "responding to PUT udpate" do

    describe "with valid params" do

      it "should update the requested board" do
        Board.should_receive(:find).with("37").and_return(mock_board)
        mock_board.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :board => {:these => 'params'}
      end

      it "should expose the requested board as @board" do
        Board.stub!(:find).and_return(mock_board(:update_attributes => true))
        put :update, :id => "1"
        assigns(:board).should equal(mock_board)
      end

      it "should redirect to the board" do
        Board.stub!(:find).and_return(mock_board(:update_attributes => true))
        put :update, :id => "1"
        response.should redirect_to(board_url(mock_board))
      end

    end
    
    describe "with invalid params" do

      it "should update the requested board" do
        Board.should_receive(:find).with("37").and_return(mock_board)
        mock_board.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :board => {:these => 'params'}
      end

      it "should expose the board as @board" do
        Board.stub!(:find).and_return(mock_board(:update_attributes => false))
        put :update, :id => "1"
        assigns(:board).should equal(mock_board)
      end

      it "should re-render the 'edit' template" do
        Board.stub!(:find).and_return(mock_board(:update_attributes => false))
        put :update, :id => "1"
        response.should render_template('edit')
      end

    end

  end

  describe "responding to DELETE destroy" do

    it "should destroy the requested board" do
      Board.should_receive(:find).with("37").and_return(mock_board)
      mock_board.should_receive(:destroy)
      delete :destroy, :id => "37"
    end
  
    it "should redirect to the boards list" do
      Board.stub!(:find).and_return(mock_board(:destroy => true))
      delete :destroy, :id => "1"
      response.should redirect_to(boards_url)
    end

  end
=end

end
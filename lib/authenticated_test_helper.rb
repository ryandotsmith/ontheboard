module AuthenticatedTestHelper
  # Sets the current user in the session from the user fixtures.
  def login_as(user)
    @request.session[:user_id] = user ? users(user).id : nil
  end

  def authorize_as(user)
    @request.env["HTTP_AUTHORIZATION"] = user ? ActionController::HttpAuthentication::Basic.encode_credentials(users(user).login, 'monkey') : nil
  end
  
  # rspec
  def mock_user
    user = mock_model(User, :id => 1,
      :login  => 'user_name',
      :name   => 'U. Surname',
      :to_xml => "User-in-XML", :to_json => "User-in-JSON", 
      :errors => [])
    user
  end  
  
  def give_me_the( who )
    current_user  = mock_model User
    board         = mock_model Board
    controller.stub!(:current_user).and_return(current_user)
    case who
      when :owner
        board.stub!(:has_role?).with('owner').and_return(true)
      when :subscriber
        board.stub!(:has_role?).with('subscriber').and_return(true)
    end
    [current_user, board]
  end

end

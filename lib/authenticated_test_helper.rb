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
  
  def give_me_the( who, what )
    current_user = mock_model User
    controller.stub!(:current_user).and_return(current_user)
    case who
      when :owner
        what.stub!(:has_role?).with('owner').and_return(true)
      when :subscriber
        what.stub!(:has_role?).with('subscriber').and_return(true)
    end
    current_user
  end
  
end

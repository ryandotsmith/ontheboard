require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe PagesController do

  def mock_user(stubs={:id => 1,:login => "ryandotsmith"})
    @mock_user ||= mock_model(User,stubs)
  end
  def mock_page(stubs={:user_id => 1})
    @mock_page ||= mock_model(Page, stubs)
  end

  describe "responding to GET show" do
    it "should expose the requested page as @page" do
      Page.should_receive(:find_by_user_id).with(@mock_user).and_return(mock_page)
      get :show, :user_name => "ryandotsmith"
      assigns[:page].should equal(mock_page)
    end    
  end

end

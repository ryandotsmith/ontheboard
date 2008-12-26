require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/pages/show.html.erb" do
  include PagesHelper
  
  before(:each) do
    assigns[:page] = @page = stub_model(Page)
  end

  it "should render attributes in <p>" do
    render "/pages/show.html.erb"
  end
end


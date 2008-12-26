require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/pages/index.html.erb" do
  include PagesHelper
  
  before(:each) do
    assigns[:pages] = [
      stub_model(Page),
      stub_model(Page)
    ]
  end

  it "should render list of pages" do
    render "/pages/index.html.erb"
  end
end


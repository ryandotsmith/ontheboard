=begin
require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/boards/index.html.erb" do
  include BoardsHelper
  
  before(:each) do
    assigns[:boards] = [
      stub_model(Board,
        :title => "value for title",
        :is_public => false
      ),
      stub_model(Board,
        :title => "value for title",
        :is_public => false
      )
    ]
  end

  it "should render list of boards" do
    render "/boards/index.html.erb"
    response.should have_tag("tr>td", "value for title", 2)
    #response.should have_tag("tr>td", false, 2)
  end
end

=end
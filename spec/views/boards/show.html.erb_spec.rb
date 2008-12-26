=begin
require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/boards/show.html.erb" do
  include BoardsHelper
  
  before(:each) do
    assigns[:board] = @board = stub_model(Board,
      :title => "value for title",
      :is_public => false
    )
  end

  it "should render attributes in <p>" do
    render "/boards/show.html.erb"
    response.should have_text(/value\ for\ title/)
    response.should have_text(/als/)
  end
end

=end
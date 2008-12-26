=begin
require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/boards/new.html.erb" do
  include BoardsHelper
  
  before(:each) do
    assigns[:board] = stub_model(Board,
      :new_record? => true,
      :title => "value for title",
      :is_public => false
    )
  end

  it "should render new form" do
    render "/boards/new.html.erb"
    
    response.should have_tag("form[action=?][method=post]", boards_path) do
      with_tag("input#board_title[name=?]", "board[title]")
      with_tag("input#board_is_public[name=?]", "board[is_public]")
    end
  end
end


=end
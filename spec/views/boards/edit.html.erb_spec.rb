=begin
require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/boards/edit.html.erb" do
  include BoardsHelper
  
  before(:each) do
    assigns[:board] = @board = stub_model(Board,
      :new_record? => false,
      :title => "value for title",
      :is_public => false
    )
  end

  it "should render edit form" do
    render "/boards/edit.html.erb"
    
    response.should have_tag("form[action=#{board_path(@board)}][method=post]") do
      with_tag('input#board_title[name=?]', "board[title]")
      with_tag('input#board_is_public[name=?]', "board[is_public]")
    end
  end
end


=end
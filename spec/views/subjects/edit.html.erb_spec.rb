require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/subjects/edit.html.erb" do
  include SubjectsHelper
  
  before(:each) do
    assigns[:subject] = @subject = stub_model(Subject,
      :new_record? => false,
      :title => "value for title"
    )
  end

  it "should render edit form" do
    render "/subjects/edit.html.erb"
    
    response.should have_tag("form[action=#{subject_path(@subject)}][method=post]") do
      with_tag('input#subject_title[name=?]', "subject[title]")
    end
  end
end



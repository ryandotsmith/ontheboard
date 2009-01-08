require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/subjects/new.html.erb" do
  include SubjectsHelper
  
  before(:each) do
    assigns[:subject] = stub_model(Subject,
      :new_record? => true,
      :title => "value for title"
    )
  end

  it "should render new form" do
    render "/subjects/new.html.erb"
    
    response.should have_tag("form[action=?][method=post]", subjects_path) do
      with_tag("input#subject_title[name=?]", "subject[title]")
    end
  end
end



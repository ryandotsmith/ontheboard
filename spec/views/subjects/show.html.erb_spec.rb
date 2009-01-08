require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/subjects/show.html.erb" do
  include SubjectsHelper
  
  before(:each) do
    assigns[:subject] = @subject = stub_model(Subject,
      :title => "value for title"
    )
  end

  it "should render attributes in <p>" do
    render "/subjects/show.html.erb"
    response.should have_text(/value\ for\ title/)
  end
end


require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/subjects/index.html.erb" do
  include SubjectsHelper
  
  before(:each) do
    assigns[:subjects] = [
      stub_model(Subject,
        :title => "value for title"
      ),
      stub_model(Subject,
        :title => "value for title"
      )
    ]
  end

  it "should render list of subjects" do
    render "/subjects/index.html.erb"
    response.should have_tag("tr>td", "value for title", 2)
  end
end


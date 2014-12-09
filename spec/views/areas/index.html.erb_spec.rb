require 'spec_helper'

describe "areas/index" do
  before(:each) do
    assign(:areas, [
      stub_model(Area,
        :nombre => "Nombre",
        :responsable => "Responsable"
      ),
      stub_model(Area,
        :nombre => "Nombre",
        :responsable => "Responsable"
      )
    ])
  end

  it "renders a list of areas" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Nombre".to_s, :count => 2
    assert_select "tr>td", :text => "Responsable".to_s, :count => 2
  end
end

require 'spec_helper'

describe "personas/index" do
  before(:each) do
    assign(:personas, [
      stub_model(Persona,
        :nombre => "Nombre",
        :apellido => "Apellido"
      ),
      stub_model(Persona,
        :nombre => "Nombre",
        :apellido => "Apellido"
      )
    ])
  end

  it "renders a list of personas" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Nombre".to_s, :count => 2
    assert_select "tr>td", :text => "Apellido".to_s, :count => 2
  end
end

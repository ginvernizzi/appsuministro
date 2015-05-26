require 'spec_helper'

describe "incisos/index" do
  before(:each) do
    assign(:incisos, [
      stub_model(Inciso,
        :codigo => "Codigo",
        :nombre => "Nombre"
      ),
      stub_model(Inciso,
        :codigo => "Codigo",
        :nombre => "Nombre"
      )
    ])
  end

  it "renders a list of incisos" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Codigo".to_s, :count => 2
    assert_select "tr>td", :text => "Nombre".to_s, :count => 2
  end
end

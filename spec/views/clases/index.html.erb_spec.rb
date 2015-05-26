require 'spec_helper'

describe "clases/index" do
  before(:each) do
    assign(:clases, [
      stub_model(Clase,
        :codigo => "Codigo",
        :nombre => "Nombre",
        :partida_parcial => nil
      ),
      stub_model(Clase,
        :codigo => "Codigo",
        :nombre => "Nombre",
        :partida_parcial => nil
      )
    ])
  end

  it "renders a list of clases" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Codigo".to_s, :count => 2
    assert_select "tr>td", :text => "Nombre".to_s, :count => 2
    assert_select "tr>td", :text => nil.to_s, :count => 2
  end
end

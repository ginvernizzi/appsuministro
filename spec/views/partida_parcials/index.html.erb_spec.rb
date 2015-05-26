require 'spec_helper'

describe "partidas_parciales/index" do
  before(:each) do
    assign(:partidas_parciales, [
      stub_model(PartidaParcial,
        :codigo => "Codigo",
        :nombre => "Nombre",
        :partida_principal => nil
      ),
      stub_model(PartidaParcial,
        :codigo => "Codigo",
        :nombre => "Nombre",
        :partida_principal => nil
      )
    ])
  end

  it "renders a list of partidas_parciales" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Codigo".to_s, :count => 2
    assert_select "tr>td", :text => "Nombre".to_s, :count => 2
    assert_select "tr>td", :text => nil.to_s, :count => 2
  end
end

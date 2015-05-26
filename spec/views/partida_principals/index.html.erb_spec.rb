require 'spec_helper'

describe "partidas_principales/index" do
  before(:each) do
    assign(:partidas_principales, [
      stub_model(PartidaPrincipal,
        :codigo => "Codigo",
        :nombre => "Nombre",
        :inciso => nil
      ),
      stub_model(PartidaPrincipal,
        :codigo => "Codigo",
        :nombre => "Nombre",
        :inciso => nil
      )
    ])
  end

  it "renders a list of partidas_principales" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Codigo".to_s, :count => 2
    assert_select "tr>td", :text => "Nombre".to_s, :count => 2
    assert_select "tr>td", :text => nil.to_s, :count => 2
  end
end

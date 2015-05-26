require 'spec_helper'

describe "partidas_parciales/show" do
  before(:each) do
    @partida_parcial = assign(:partida_parcial, stub_model(PartidaParcial,
      :codigo => "Codigo",
      :nombre => "Nombre",
      :partida_principal => nil
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Codigo/)
    rendered.should match(/Nombre/)
    rendered.should match(//)
  end
end

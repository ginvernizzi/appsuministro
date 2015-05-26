require 'spec_helper'

describe "partidas_principales/show" do
  before(:each) do
    @partida_principal = assign(:partida_principal, stub_model(PartidaPrincipal,
      :codigo => "Codigo",
      :nombre => "Nombre",
      :inciso => nil
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

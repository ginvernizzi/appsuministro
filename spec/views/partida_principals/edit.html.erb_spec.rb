require 'spec_helper'

describe "partidas_principales/edit" do
  before(:each) do
    @partida_principal = assign(:partida_principal, stub_model(PartidaPrincipal,
      :codigo => "MyString",
      :nombre => "MyString",
      :inciso => nil
    ))
  end

  it "renders the edit partida_principal form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", partida_principal_path(@partida_principal), "post" do
      assert_select "input#partida_principal_codigo[name=?]", "partida_principal[codigo]"
      assert_select "input#partida_principal_nombre[name=?]", "partida_principal[nombre]"
      assert_select "input#partida_principal_inciso[name=?]", "partida_principal[inciso]"
    end
  end
end

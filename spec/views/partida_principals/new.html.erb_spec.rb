require 'spec_helper'

describe "partidas_principales/new" do
  before(:each) do
    assign(:partida_principal, stub_model(PartidaPrincipal,
      :codigo => "MyString",
      :nombre => "MyString",
      :inciso => nil
    ).as_new_record)
  end

  it "renders new partida_principal form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", partidas_principales_path, "post" do
      assert_select "input#partida_principal_codigo[name=?]", "partida_principal[codigo]"
      assert_select "input#partida_principal_nombre[name=?]", "partida_principal[nombre]"
      assert_select "input#partida_principal_inciso[name=?]", "partida_principal[inciso]"
    end
  end
end

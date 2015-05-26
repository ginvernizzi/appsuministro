require 'spec_helper'

describe "partidas_parciales/new" do
  before(:each) do
    assign(:partida_parcial, stub_model(PartidaParcial,
      :codigo => "MyString",
      :nombre => "MyString",
      :partida_principal => nil
    ).as_new_record)
  end

  it "renders new partida_parcial form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", partidas_parciales_path, "post" do
      assert_select "input#partida_parcial_codigo[name=?]", "partida_parcial[codigo]"
      assert_select "input#partida_parcial_nombre[name=?]", "partida_parcial[nombre]"
      assert_select "input#partida_parcial_partida_principal[name=?]", "partida_parcial[partida_principal]"
    end
  end
end

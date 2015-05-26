require 'spec_helper'

describe "clases/edit" do
  before(:each) do
    @clase = assign(:clase, stub_model(Clase,
      :codigo => "MyString",
      :nombre => "MyString",
      :partida_parcial => nil
    ))
  end

  it "renders the edit clase form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", clase_path(@clase), "post" do
      assert_select "input#clase_codigo[name=?]", "clase[codigo]"
      assert_select "input#clase_nombre[name=?]", "clase[nombre]"
      assert_select "input#clase_partida_parcial[name=?]", "clase[partida_parcial]"
    end
  end
end

require 'spec_helper'

describe "recepciones_de_bien_de_consumo/edit" do
  before(:each) do
    @recepcion_de_bien_de_consumo = assign(:recepcion_de_bien_de_consumo, stub_model(RecepcionDeBienDeConsumo,
      :estado => 1,
      :descripcion_provisoria => "MyText"
    ))
  end

  it "renders the edit recepcion_de_bien_de_consumo form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", recepcion_de_bien_de_consumo_path(@recepcion_de_bien_de_consumo), "post" do
      assert_select "input#recepcion_de_bien_de_consumo_estado[name=?]", "recepcion_de_bien_de_consumo[estado]"
      assert_select "textarea#recepcion_de_bien_de_consumo_descripcion_provisoria[name=?]", "recepcion_de_bien_de_consumo[descripcion_provisoria]"
    end
  end
end

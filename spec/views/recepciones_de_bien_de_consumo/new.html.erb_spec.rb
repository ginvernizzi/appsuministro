require 'spec_helper'

describe "recepciones_de_bien_de_consumo/new" do
  before(:each) do
    assign(:recepcion_de_bien_de_consumo, stub_model(RecepcionDeBienDeConsumo,
      :estado => 1,
      :descripcion_provisoria => "MyText"
    ).as_new_record)
  end

  it "renders new recepcion_de_bien_de_consumo form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", recepciones_de_bien_de_consumo_path, "post" do
      assert_select "input#recepcion_de_bien_de_consumo_estado[name=?]", "recepcion_de_bien_de_consumo[estado]"
      assert_select "textarea#recepcion_de_bien_de_consumo_descripcion_provisoria[name=?]", "recepcion_de_bien_de_consumo[descripcion_provisoria]"
    end
  end
end

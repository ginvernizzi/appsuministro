require 'spec_helper'

describe "recepciones_de_bien_de_consumo/show" do
  before(:each) do
    @recepcion_de_bien_de_consumo = assign(:recepcion_de_bien_de_consumo, stub_model(RecepcionDeBienDeConsumo,
      :estado => 1,
      :descripcion_provisoria => "MyText"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
    rendered.should match(/MyText/)
  end
end

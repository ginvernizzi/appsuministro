require 'spec_helper'

describe "recepciones_de_bien_de_consumo/index" do
  before(:each) do
    assign(:recepciones_de_bien_de_consumo, [
      stub_model(RecepcionDeBienDeConsumo,
        :estado => 1,
        :descripcion_provisoria => "MyText"
      ),
      stub_model(RecepcionDeBienDeConsumo,
        :estado => 1,
        :descripcion_provisoria => "MyText"
      )
    ])
  end

  it "renders a list of recepciones_de_bien_de_consumo" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
  end
end

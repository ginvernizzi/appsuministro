require 'spec_helper'

describe "obras_proyectos/index" do
  before(:each) do
    assign(:obras_proyectos, [
      stub_model(ObraProyecto,
        :codigo => "Codigo",
        :descripcion => "Descripcion"
      ),
      stub_model(ObraProyecto,
        :codigo => "Codigo",
        :descripcion => "Descripcion"
      )
    ])
  end

  it "renders a list of obras_proyectos" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Codigo".to_s, :count => 2
    assert_select "tr>td", :text => "Descripcion".to_s, :count => 2
  end
end

require 'spec_helper'

describe "obras_proyectos/edit" do
  before(:each) do
    @obra_proyecto = assign(:obra_proyecto, stub_model(ObraProyecto,
      :codigo => "MyString",
      :descripcion => "MyString"
    ))
  end

  it "renders the edit obra_proyecto form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", obra_proyecto_path(@obra_proyecto), "post" do
      assert_select "input#obra_proyecto_codigo[name=?]", "obra_proyecto[codigo]"
      assert_select "input#obra_proyecto_descripcion[name=?]", "obra_proyecto[descripcion]"
    end
  end
end

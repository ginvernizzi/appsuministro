require 'spec_helper'

describe "obras_proyectos/new" do
  before(:each) do
    assign(:obra_proyecto, stub_model(ObraProyecto,
      :codigo => "MyString",
      :descripcion => "MyString"
    ).as_new_record)
  end

  it "renders new obra_proyecto form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", obras_proyectos_path, "post" do
      assert_select "input#obra_proyecto_codigo[name=?]", "obra_proyecto[codigo]"
      assert_select "input#obra_proyecto_descripcion[name=?]", "obra_proyecto[descripcion]"
    end
  end
end

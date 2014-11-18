require 'spec_helper'

describe "obras_proyectos/show" do
  before(:each) do
    @obra_proyecto = assign(:obra_proyecto, stub_model(ObraProyecto,
      :codigo => "Codigo",
      :descripcion => "Descripcion"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Codigo/)
    rendered.should match(/Descripcion/)
  end
end

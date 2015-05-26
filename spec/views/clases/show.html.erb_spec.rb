require 'spec_helper'

describe "clases/show" do
  before(:each) do
    @clase = assign(:clase, stub_model(Clase,
      :codigo => "Codigo",
      :nombre => "Nombre",
      :partida_parcial => nil
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Codigo/)
    rendered.should match(/Nombre/)
    rendered.should match(//)
  end
end

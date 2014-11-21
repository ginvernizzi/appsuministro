require 'spec_helper'

describe "consumos_directo/show" do
  before(:each) do
    @consumo_directo = assign(:consumo_directo, stub_model(ConsumoDirecto,
      :area => "Area",
      :obra_proyecto => nil
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Area/)
    rendered.should match(//)
  end
end

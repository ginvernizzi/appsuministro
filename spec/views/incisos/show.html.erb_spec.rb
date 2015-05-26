require 'spec_helper'

describe "incisos/show" do
  before(:each) do
    @inciso = assign(:inciso, stub_model(Inciso,
      :codigo => "Codigo",
      :nombre => "Nombre"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Codigo/)
    rendered.should match(/Nombre/)
  end
end

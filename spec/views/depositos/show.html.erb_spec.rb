require 'spec_helper'

describe "depositos/show" do
  before(:each) do
    @deposito = assign(:deposito, stub_model(Deposito,
      :nombre => "Nombre",
      :area => nil
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Nombre/)
    rendered.should match(//)
  end
end

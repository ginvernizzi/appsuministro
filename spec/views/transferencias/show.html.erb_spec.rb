require 'spec_helper'

describe "transferencias/show" do
  before(:each) do
    @transferencia = assign(:transferencia, stub_model(Transferencia,
      :area => nil,
      :deposito_origen => nil,
      :deposito_destino => nil
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(//)
    rendered.should match(//)
    rendered.should match(//)
  end
end

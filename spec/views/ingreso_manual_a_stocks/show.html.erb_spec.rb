require 'spec_helper'

describe "ingreso_manual_a_stocks/show" do
  before(:each) do
    @ingreso_manual_a_stock = assign(:ingreso_manual_a_stock, stub_model(IngresoManualAStock))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end

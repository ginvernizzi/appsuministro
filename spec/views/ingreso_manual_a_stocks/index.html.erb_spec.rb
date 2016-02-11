require 'spec_helper'

describe "ingreso_manual_a_stocks/index" do
  before(:each) do
    assign(:ingreso_manual_a_stocks, [
      stub_model(IngresoManualAStock),
      stub_model(IngresoManualAStock)
    ])
  end

  it "renders a list of ingreso_manual_a_stocks" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end

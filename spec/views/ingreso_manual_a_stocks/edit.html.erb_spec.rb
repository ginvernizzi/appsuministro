require 'spec_helper'

describe "ingreso_manual_a_stocks/edit" do
  before(:each) do
    @ingreso_manual_a_stock = assign(:ingreso_manual_a_stock, stub_model(IngresoManualAStock))
  end

  it "renders the edit ingreso_manual_a_stock form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", ingreso_manual_a_stock_path(@ingreso_manual_a_stock), "post" do
    end
  end
end

require 'spec_helper'

describe "ingreso_manual_a_stocks/new" do
  before(:each) do
    assign(:ingreso_manual_a_stock, stub_model(IngresoManualAStock).as_new_record)
  end

  it "renders new ingreso_manual_a_stock form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", ingreso_manual_a_stocks_path, "post" do
    end
  end
end

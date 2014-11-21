require 'spec_helper'

describe "consumos_directo/new" do
  before(:each) do
    assign(:consumo_directo, stub_model(ConsumoDirecto,
      :area => "MyString",
      :obra_proyecto => nil
    ).as_new_record)
  end

  it "renders new consumo_directo form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", consumos_directo_path, "post" do
      assert_select "input#consumo_directo_area[name=?]", "consumo_directo[area]"
      assert_select "input#consumo_directo_obra_proyecto[name=?]", "consumo_directo[obra_proyecto]"
    end
  end
end

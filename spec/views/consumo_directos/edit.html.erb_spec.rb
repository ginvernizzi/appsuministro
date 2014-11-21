require 'spec_helper'

describe "consumos_directo/edit" do
  before(:each) do
    @consumo_directo = assign(:consumo_directo, stub_model(ConsumoDirecto,
      :area => "MyString",
      :obra_proyecto => nil
    ))
  end

  it "renders the edit consumo_directo form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", consumo_directo_path(@consumo_directo), "post" do
      assert_select "input#consumo_directo_area[name=?]", "consumo_directo[area]"
      assert_select "input#consumo_directo_obra_proyecto[name=?]", "consumo_directo[obra_proyecto]"
    end
  end
end

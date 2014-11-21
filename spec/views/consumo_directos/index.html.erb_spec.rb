require 'spec_helper'

describe "consumos_directo/index" do
  before(:each) do
    assign(:consumos_directo, [
      stub_model(ConsumoDirecto,
        :area => "Area",
        :obra_proyecto => nil
      ),
      stub_model(ConsumoDirecto,
        :area => "Area",
        :obra_proyecto => nil
      )
    ])
  end

  it "renders a list of consumos_directo" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Area".to_s, :count => 2
    assert_select "tr>td", :text => nil.to_s, :count => 2
  end
end

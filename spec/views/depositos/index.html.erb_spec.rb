require 'spec_helper'

describe "depositos/index" do
  before(:each) do
    assign(:depositos, [
      stub_model(Deposito,
        :nombre => "Nombre",
        :area => nil
      ),
      stub_model(Deposito,
        :nombre => "Nombre",
        :area => nil
      )
    ])
  end

  it "renders a list of depositos" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Nombre".to_s, :count => 2
    assert_select "tr>td", :text => nil.to_s, :count => 2
  end
end

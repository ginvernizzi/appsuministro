require 'spec_helper'

describe "transferencias/index" do
  before(:each) do
    assign(:transferencias, [
      stub_model(Transferencia,
        :area => nil,
        :deposito_origen => nil,
        :deposito_destino => nil
      ),
      stub_model(Transferencia,
        :area => nil,
        :deposito_origen => nil,
        :deposito_destino => nil
      )
    ])
  end

  it "renders a list of transferencias" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => nil.to_s, :count => 2
  end
end

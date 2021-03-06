require 'spec_helper'

describe "transferencias/edit" do
  before(:each) do
    @transferencia = assign(:transferencia, stub_model(Transferencia,
      :area => nil,
      :deposito_origen => nil,
      :deposito_destino => nil
    ))
  end

  it "renders the edit transferencia form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", transferencia_path(@transferencia), "post" do
      assert_select "input#transferencia_area[name=?]", "transferencia[area]"
      assert_select "input#transferencia_deposito_origen[name=?]", "transferencia[deposito_origen]"
      assert_select "input#transferencia_deposito_destino[name=?]", "transferencia[deposito_destino]"
    end
  end
end

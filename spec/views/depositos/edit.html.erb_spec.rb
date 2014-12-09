require 'spec_helper'

describe "depositos/edit" do
  before(:each) do
    @deposito = assign(:deposito, stub_model(Deposito,
      :nombre => "MyString",
      :area => nil
    ))
  end

  it "renders the edit deposito form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", deposito_path(@deposito), "post" do
      assert_select "input#deposito_nombre[name=?]", "deposito[nombre]"
      assert_select "input#deposito_area[name=?]", "deposito[area]"
    end
  end
end

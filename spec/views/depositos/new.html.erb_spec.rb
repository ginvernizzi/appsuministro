require 'spec_helper'

describe "depositos/new" do
  before(:each) do
    assign(:deposito, stub_model(Deposito,
      :nombre => "MyString",
      :area => nil
    ).as_new_record)
  end

  it "renders new deposito form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", depositos_path, "post" do
      assert_select "input#deposito_nombre[name=?]", "deposito[nombre]"
      assert_select "input#deposito_area[name=?]", "deposito[area]"
    end
  end
end

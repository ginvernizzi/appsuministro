require 'spec_helper'

describe "incisos/edit" do
  before(:each) do
    @inciso = assign(:inciso, stub_model(Inciso,
      :codigo => "MyString",
      :nombre => "MyString"
    ))
  end

  it "renders the edit inciso form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", inciso_path(@inciso), "post" do
      assert_select "input#inciso_codigo[name=?]", "inciso[codigo]"
      assert_select "input#inciso_nombre[name=?]", "inciso[nombre]"
    end
  end
end

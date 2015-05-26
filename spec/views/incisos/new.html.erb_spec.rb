require 'spec_helper'

describe "incisos/new" do
  before(:each) do
    assign(:inciso, stub_model(Inciso,
      :codigo => "MyString",
      :nombre => "MyString"
    ).as_new_record)
  end

  it "renders new inciso form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", incisos_path, "post" do
      assert_select "input#inciso_codigo[name=?]", "inciso[codigo]"
      assert_select "input#inciso_nombre[name=?]", "inciso[nombre]"
    end
  end
end

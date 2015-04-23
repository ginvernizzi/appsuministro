require 'spec_helper'

describe "personas/edit" do
  before(:each) do
    @persona = assign(:persona, stub_model(Persona,
      :nombre => "MyString",
      :apellido => "MyString"
    ))
  end

  it "renders the edit persona form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", persona_path(@persona), "post" do
      assert_select "input#persona_nombre[name=?]", "persona[nombre]"
      assert_select "input#persona_apellido[name=?]", "persona[apellido]"
    end
  end
end

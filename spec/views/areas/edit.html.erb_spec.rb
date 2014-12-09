require 'spec_helper'

describe "areas/edit" do
  before(:each) do
    @area = assign(:area, stub_model(Area,
      :nombre => "MyString",
      :responsable => "MyString"
    ))
  end

  it "renders the edit area form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", area_path(@area), "post" do
      assert_select "input#area_nombre[name=?]", "area[nombre]"
      assert_select "input#area_responsable[name=?]", "area[responsable]"
    end
  end
end

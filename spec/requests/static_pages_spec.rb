require 'spec_helper'

describe "Static pages" do

  describe "Home page" do

    it "should have the content 'Suministro'" do
      visit '/static_pages/home'
      expect(page).to have_content('Suministro')
    end
  end
end

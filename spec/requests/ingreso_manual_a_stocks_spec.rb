require 'spec_helper'

describe "IngresoManualAStocks" do
  describe "GET /ingreso_manual_a_stocks" do
    it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get ingreso_manual_a_stocks_path
      response.status.should be(200)
    end
  end
end

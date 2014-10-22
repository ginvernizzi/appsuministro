require 'spec_helper'

describe "RecepcionDeBienDeConsumos" do
  describe "GET /recepciones_de_bien_de_consumo" do
    it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get recepciones_de_bien_de_consumo_path
      response.status.should be(200)
    end
  end
end

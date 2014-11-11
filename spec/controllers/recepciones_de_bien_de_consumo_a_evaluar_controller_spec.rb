require 'spec_helper'

describe RecepcionesDeBienDeConsumoAEvaluarController do

  describe "GET 'index'" do
    it "returns http success" do
      get 'index'
      response.should be_success
    end
  end

end

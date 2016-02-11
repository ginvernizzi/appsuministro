require "spec_helper"

describe IngresoManualAStocksController do
  describe "routing" do

    it "routes to #index" do
      get("/ingreso_manual_a_stocks").should route_to("ingreso_manual_a_stocks#index")
    end

    it "routes to #new" do
      get("/ingreso_manual_a_stocks/new").should route_to("ingreso_manual_a_stocks#new")
    end

    it "routes to #show" do
      get("/ingreso_manual_a_stocks/1").should route_to("ingreso_manual_a_stocks#show", :id => "1")
    end

    it "routes to #edit" do
      get("/ingreso_manual_a_stocks/1/edit").should route_to("ingreso_manual_a_stocks#edit", :id => "1")
    end

    it "routes to #create" do
      post("/ingreso_manual_a_stocks").should route_to("ingreso_manual_a_stocks#create")
    end

    it "routes to #update" do
      put("/ingreso_manual_a_stocks/1").should route_to("ingreso_manual_a_stocks#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/ingreso_manual_a_stocks/1").should route_to("ingreso_manual_a_stocks#destroy", :id => "1")
    end

  end
end

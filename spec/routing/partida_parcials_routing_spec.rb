require "spec_helper"

describe PartidaParcialsController do
  describe "routing" do

    it "routes to #index" do
      get("/partidas_parciales").should route_to("partidas_parciales#index")
    end

    it "routes to #new" do
      get("/partidas_parciales/new").should route_to("partidas_parciales#new")
    end

    it "routes to #show" do
      get("/partidas_parciales/1").should route_to("partidas_parciales#show", :id => "1")
    end

    it "routes to #edit" do
      get("/partidas_parciales/1/edit").should route_to("partidas_parciales#edit", :id => "1")
    end

    it "routes to #create" do
      post("/partidas_parciales").should route_to("partidas_parciales#create")
    end

    it "routes to #update" do
      put("/partidas_parciales/1").should route_to("partidas_parciales#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/partidas_parciales/1").should route_to("partidas_parciales#destroy", :id => "1")
    end

  end
end

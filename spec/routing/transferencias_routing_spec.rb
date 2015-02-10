require "spec_helper"

describe TransferenciasController do
  describe "routing" do

    it "routes to #index" do
      get("/transferencias").should route_to("transferencias#index")
    end

    it "routes to #new" do
      get("/transferencias/new").should route_to("transferencias#new")
    end

    it "routes to #show" do
      get("/transferencias/1").should route_to("transferencias#show", :id => "1")
    end

    it "routes to #edit" do
      get("/transferencias/1/edit").should route_to("transferencias#edit", :id => "1")
    end

    it "routes to #create" do
      post("/transferencias").should route_to("transferencias#create")
    end

    it "routes to #update" do
      put("/transferencias/1").should route_to("transferencias#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/transferencias/1").should route_to("transferencias#destroy", :id => "1")
    end

  end
end

require "spec_helper"

describe PartidaPrincipalsController do
  describe "routing" do

    it "routes to #index" do
      get("/partidas_principales").should route_to("partidas_principales#index")
    end

    it "routes to #new" do
      get("/partidas_principales/new").should route_to("partidas_principales#new")
    end

    it "routes to #show" do
      get("/partidas_principales/1").should route_to("partidas_principales#show", :id => "1")
    end

    it "routes to #edit" do
      get("/partidas_principales/1/edit").should route_to("partidas_principales#edit", :id => "1")
    end

    it "routes to #create" do
      post("/partidas_principales").should route_to("partidas_principales#create")
    end

    it "routes to #update" do
      put("/partidas_principales/1").should route_to("partidas_principales#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/partidas_principales/1").should route_to("partidas_principales#destroy", :id => "1")
    end

  end
end

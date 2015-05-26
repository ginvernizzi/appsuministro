require "spec_helper"

describe IncisosController do
  describe "routing" do

    it "routes to #index" do
      get("/incisos").should route_to("incisos#index")
    end

    it "routes to #new" do
      get("/incisos/new").should route_to("incisos#new")
    end

    it "routes to #show" do
      get("/incisos/1").should route_to("incisos#show", :id => "1")
    end

    it "routes to #edit" do
      get("/incisos/1/edit").should route_to("incisos#edit", :id => "1")
    end

    it "routes to #create" do
      post("/incisos").should route_to("incisos#create")
    end

    it "routes to #update" do
      put("/incisos/1").should route_to("incisos#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/incisos/1").should route_to("incisos#destroy", :id => "1")
    end

  end
end

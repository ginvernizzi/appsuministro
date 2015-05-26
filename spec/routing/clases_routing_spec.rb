require "spec_helper"

describe ClasesController do
  describe "routing" do

    it "routes to #index" do
      get("/clases").should route_to("clases#index")
    end

    it "routes to #new" do
      get("/clases/new").should route_to("clases#new")
    end

    it "routes to #show" do
      get("/clases/1").should route_to("clases#show", :id => "1")
    end

    it "routes to #edit" do
      get("/clases/1/edit").should route_to("clases#edit", :id => "1")
    end

    it "routes to #create" do
      post("/clases").should route_to("clases#create")
    end

    it "routes to #update" do
      put("/clases/1").should route_to("clases#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/clases/1").should route_to("clases#destroy", :id => "1")
    end

  end
end

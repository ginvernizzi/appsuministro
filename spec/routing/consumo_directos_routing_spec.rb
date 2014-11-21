require "spec_helper"

describe ConsumoDirectosController do
  describe "routing" do

    it "routes to #index" do
      get("/consumos_directo").should route_to("consumos_directo#index")
    end

    it "routes to #new" do
      get("/consumos_directo/new").should route_to("consumos_directo#new")
    end

    it "routes to #show" do
      get("/consumos_directo/1").should route_to("consumos_directo#show", :id => "1")
    end

    it "routes to #edit" do
      get("/consumos_directo/1/edit").should route_to("consumos_directo#edit", :id => "1")
    end

    it "routes to #create" do
      post("/consumos_directo").should route_to("consumos_directo#create")
    end

    it "routes to #update" do
      put("/consumos_directo/1").should route_to("consumos_directo#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/consumos_directo/1").should route_to("consumos_directo#destroy", :id => "1")
    end

  end
end

require "spec_helper"

describe DepositosController do
  describe "routing" do

    it "routes to #index" do
      get("/depositos").should route_to("depositos#index")
    end

    it "routes to #new" do
      get("/depositos/new").should route_to("depositos#new")
    end

    it "routes to #show" do
      get("/depositos/1").should route_to("depositos#show", :id => "1")
    end

    it "routes to #edit" do
      get("/depositos/1/edit").should route_to("depositos#edit", :id => "1")
    end

    it "routes to #create" do
      post("/depositos").should route_to("depositos#create")
    end

    it "routes to #update" do
      put("/depositos/1").should route_to("depositos#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/depositos/1").should route_to("depositos#destroy", :id => "1")
    end

  end
end

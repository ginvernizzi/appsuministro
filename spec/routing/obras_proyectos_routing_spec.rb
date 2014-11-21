require "spec_helper"

describe ObrasProyectosController do
  describe "routing" do

    it "routes to #index" do
      get("/obras_proyectos").should route_to("obras_proyectos#index")
    end

    it "routes to #new" do
      get("/obras_proyectos/new").should route_to("obras_proyectos#new")
    end

    it "routes to #show" do
      get("/obras_proyectos/1").should route_to("obras_proyectos#show", :id => "1")
    end

    it "routes to #edit" do
      get("/obras_proyectos/1/edit").should route_to("obras_proyectos#edit", :id => "1")
    end

    it "routes to #create" do
      post("/obras_proyectos").should route_to("obras_proyectos#create")
    end

    it "routes to #update" do
      put("/obras_proyectos/1").should route_to("obras_proyectos#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/obras_proyectos/1").should route_to("obras_proyectos#destroy", :id => "1")
    end

  end
end

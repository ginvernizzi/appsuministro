require "spec_helper"

describe RecepcionesDeBienDeConsumoController do
  describe "routing" do

    it "routes to #index" do
      get("/recepciones_de_bien_de_consumo").should route_to("recepciones_de_bien_de_consumo#index")
    end

    it "routes to #new" do
      get("/recepciones_de_bien_de_consumo/new").should route_to("recepciones_de_bien_de_consumo#new")
    end

    it "routes to #show" do
      get("/recepciones_de_bien_de_consumo/1").should route_to("recepciones_de_bien_de_consumo#show", :id => "1")
    end

    it "routes to #edit" do
      get("/recepciones_de_bien_de_consumo/1/edit").should route_to("recepciones_de_bien_de_consumo#edit", :id => "1")
    end

    it "routes to #create" do
      post("/recepciones_de_bien_de_consumo").should route_to("recepciones_de_bien_de_consumo#create")
    end

    it "routes to #update" do
      put("/recepciones_de_bien_de_consumo/1").should route_to("recepciones_de_bien_de_consumo#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/recepciones_de_bien_de_consumo/1").should route_to("recepciones_de_bien_de_consumo#destroy", :id => "1")
    end

  end
end

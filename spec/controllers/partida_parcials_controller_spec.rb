require 'spec_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator.  If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails.  There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.
#
# Compared to earlier versions of this generator, there is very limited use of
# stubs and message expectations in this spec.  Stubs are only used when there
# is no simpler way to get a handle on the object needed for the example.
# Message expectations are only used when there is no simpler way to specify
# that an instance is receiving a specific message.

describe PartidaParcialsController do

  # This should return the minimal set of attributes required to create a valid
  # PartidaParcial. As you add validations to PartidaParcial, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) { { "codigo" => "MyString" } }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # PartidaParcialsController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  describe "GET index" do
    it "assigns all partidas_parciales as @partidas_parciales" do
      partida_parcial = PartidaParcial.create! valid_attributes
      get :index, {}, valid_session
      assigns(:partidas_parciales).should eq([partida_parcial])
    end
  end

  describe "GET show" do
    it "assigns the requested partida_parcial as @partida_parcial" do
      partida_parcial = PartidaParcial.create! valid_attributes
      get :show, {:id => partida_parcial.to_param}, valid_session
      assigns(:partida_parcial).should eq(partida_parcial)
    end
  end

  describe "GET new" do
    it "assigns a new partida_parcial as @partida_parcial" do
      get :new, {}, valid_session
      assigns(:partida_parcial).should be_a_new(PartidaParcial)
    end
  end

  describe "GET edit" do
    it "assigns the requested partida_parcial as @partida_parcial" do
      partida_parcial = PartidaParcial.create! valid_attributes
      get :edit, {:id => partida_parcial.to_param}, valid_session
      assigns(:partida_parcial).should eq(partida_parcial)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new PartidaParcial" do
        expect {
          post :create, {:partida_parcial => valid_attributes}, valid_session
        }.to change(PartidaParcial, :count).by(1)
      end

      it "assigns a newly created partida_parcial as @partida_parcial" do
        post :create, {:partida_parcial => valid_attributes}, valid_session
        assigns(:partida_parcial).should be_a(PartidaParcial)
        assigns(:partida_parcial).should be_persisted
      end

      it "redirects to the created partida_parcial" do
        post :create, {:partida_parcial => valid_attributes}, valid_session
        response.should redirect_to(PartidaParcial.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved partida_parcial as @partida_parcial" do
        # Trigger the behavior that occurs when invalid params are submitted
        PartidaParcial.any_instance.stub(:save).and_return(false)
        post :create, {:partida_parcial => { "codigo" => "invalid value" }}, valid_session
        assigns(:partida_parcial).should be_a_new(PartidaParcial)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        PartidaParcial.any_instance.stub(:save).and_return(false)
        post :create, {:partida_parcial => { "codigo" => "invalid value" }}, valid_session
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested partida_parcial" do
        partida_parcial = PartidaParcial.create! valid_attributes
        # Assuming there are no other partidas_parciales in the database, this
        # specifies that the PartidaParcial created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        PartidaParcial.any_instance.should_receive(:update).with({ "codigo" => "MyString" })
        put :update, {:id => partida_parcial.to_param, :partida_parcial => { "codigo" => "MyString" }}, valid_session
      end

      it "assigns the requested partida_parcial as @partida_parcial" do
        partida_parcial = PartidaParcial.create! valid_attributes
        put :update, {:id => partida_parcial.to_param, :partida_parcial => valid_attributes}, valid_session
        assigns(:partida_parcial).should eq(partida_parcial)
      end

      it "redirects to the partida_parcial" do
        partida_parcial = PartidaParcial.create! valid_attributes
        put :update, {:id => partida_parcial.to_param, :partida_parcial => valid_attributes}, valid_session
        response.should redirect_to(partida_parcial)
      end
    end

    describe "with invalid params" do
      it "assigns the partida_parcial as @partida_parcial" do
        partida_parcial = PartidaParcial.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        PartidaParcial.any_instance.stub(:save).and_return(false)
        put :update, {:id => partida_parcial.to_param, :partida_parcial => { "codigo" => "invalid value" }}, valid_session
        assigns(:partida_parcial).should eq(partida_parcial)
      end

      it "re-renders the 'edit' template" do
        partida_parcial = PartidaParcial.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        PartidaParcial.any_instance.stub(:save).and_return(false)
        put :update, {:id => partida_parcial.to_param, :partida_parcial => { "codigo" => "invalid value" }}, valid_session
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested partida_parcial" do
      partida_parcial = PartidaParcial.create! valid_attributes
      expect {
        delete :destroy, {:id => partida_parcial.to_param}, valid_session
      }.to change(PartidaParcial, :count).by(-1)
    end

    it "redirects to the partidas_parciales list" do
      partida_parcial = PartidaParcial.create! valid_attributes
      delete :destroy, {:id => partida_parcial.to_param}, valid_session
      response.should redirect_to(partidas_parciales_url)
    end
  end

end

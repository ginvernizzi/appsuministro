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

describe ConsumosDirectoController do

  # This should return the minimal set of attributes required to create a valid
  # ConsumoDirecto. As you add validations to ConsumoDirecto, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) { { "fecha" => "2014-11-20" } }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # ConsumoDirectosController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  describe "GET index" do
    it "assigns all consumos_directo as @consumos_directo" do
      consumo_directo = ConsumoDirecto.create! valid_attributes
      get :index, {}, valid_session
      assigns(:consumos_directo).should eq([consumo_directo])
    end
  end

  describe "GET show" do
    it "assigns the requested consumo_directo as @consumo_directo" do
      consumo_directo = ConsumoDirecto.create! valid_attributes
      get :show, {:id => consumo_directo.to_param}, valid_session
      assigns(:consumo_directo).should eq(consumo_directo)
    end
  end

  describe "GET new" do
    it "assigns a new consumo_directo as @consumo_directo" do
      get :new, {}, valid_session
      assigns(:consumo_directo).should be_a_new(ConsumoDirecto)
    end
  end

  describe "GET edit" do
    it "assigns the requested consumo_directo as @consumo_directo" do
      consumo_directo = ConsumoDirecto.create! valid_attributes
      get :edit, {:id => consumo_directo.to_param}, valid_session
      assigns(:consumo_directo).should eq(consumo_directo)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new ConsumoDirecto" do
        expect {
          post :create, {:consumo_directo => valid_attributes}, valid_session
        }.to change(ConsumoDirecto, :count).by(1)
      end

      it "assigns a newly created consumo_directo as @consumo_directo" do
        post :create, {:consumo_directo => valid_attributes}, valid_session
        assigns(:consumo_directo).should be_a(ConsumoDirecto)
        assigns(:consumo_directo).should be_persisted
      end

      it "redirects to the created consumo_directo" do
        post :create, {:consumo_directo => valid_attributes}, valid_session
        response.should redirect_to(ConsumoDirecto.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved consumo_directo as @consumo_directo" do
        # Trigger the behavior that occurs when invalid params are submitted
        ConsumoDirecto.any_instance.stub(:save).and_return(false)
        post :create, {:consumo_directo => { "fecha" => "invalid value" }}, valid_session
        assigns(:consumo_directo).should be_a_new(ConsumoDirecto)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        ConsumoDirecto.any_instance.stub(:save).and_return(false)
        post :create, {:consumo_directo => { "fecha" => "invalid value" }}, valid_session
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested consumo_directo" do
        consumo_directo = ConsumoDirecto.create! valid_attributes
        # Assuming there are no other consumos_directo in the database, this
        # specifies that the ConsumoDirecto created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        ConsumoDirecto.any_instance.should_receive(:update).with({ "fecha" => "2014-11-20" })
        put :update, {:id => consumo_directo.to_param, :consumo_directo => { "fecha" => "2014-11-20" }}, valid_session
      end

      it "assigns the requested consumo_directo as @consumo_directo" do
        consumo_directo = ConsumoDirecto.create! valid_attributes
        put :update, {:id => consumo_directo.to_param, :consumo_directo => valid_attributes}, valid_session
        assigns(:consumo_directo).should eq(consumo_directo)
      end

      it "redirects to the consumo_directo" do
        consumo_directo = ConsumoDirecto.create! valid_attributes
        put :update, {:id => consumo_directo.to_param, :consumo_directo => valid_attributes}, valid_session
        response.should redirect_to(consumo_directo)
      end
    end

    describe "with invalid params" do
      it "assigns the consumo_directo as @consumo_directo" do
        consumo_directo = ConsumoDirecto.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        ConsumoDirecto.any_instance.stub(:save).and_return(false)
        put :update, {:id => consumo_directo.to_param, :consumo_directo => { "fecha" => "invalid value" }}, valid_session
        assigns(:consumo_directo).should eq(consumo_directo)
      end

      it "re-renders the 'edit' template" do
        consumo_directo = ConsumoDirecto.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        ConsumoDirecto.any_instance.stub(:save).and_return(false)
        put :update, {:id => consumo_directo.to_param, :consumo_directo => { "fecha" => "invalid value" }}, valid_session
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested consumo_directo" do
      consumo_directo = ConsumoDirecto.create! valid_attributes
      expect {
        delete :destroy, {:id => consumo_directo.to_param}, valid_session
      }.to change(ConsumoDirecto, :count).by(-1)
    end

    it "redirects to the consumos_directo list" do
      consumo_directo = ConsumoDirecto.create! valid_attributes
      delete :destroy, {:id => consumo_directo.to_param}, valid_session
      response.should redirect_to(consumos_directo_url)
    end
  end

end

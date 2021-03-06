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

describe DepositosController do

  # This should return the minimal set of attributes required to create a valid
  # Deposito. As you add validations to Deposito, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) { { "nombre" => "MyString" } }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # DepositosController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  describe "GET index" do
    it "assigns all depositos as @depositos" do
      deposito = Deposito.create! valid_attributes
      get :index, {}, valid_session
      assigns(:depositos).should eq([deposito])
    end
  end

  describe "GET show" do
    it "assigns the requested deposito as @deposito" do
      deposito = Deposito.create! valid_attributes
      get :show, {:id => deposito.to_param}, valid_session
      assigns(:deposito).should eq(deposito)
    end
  end

  describe "GET new" do
    it "assigns a new deposito as @deposito" do
      get :new, {}, valid_session
      assigns(:deposito).should be_a_new(Deposito)
    end
  end

  describe "GET edit" do
    it "assigns the requested deposito as @deposito" do
      deposito = Deposito.create! valid_attributes
      get :edit, {:id => deposito.to_param}, valid_session
      assigns(:deposito).should eq(deposito)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Deposito" do
        expect {
          post :create, {:deposito => valid_attributes}, valid_session
        }.to change(Deposito, :count).by(1)
      end

      it "assigns a newly created deposito as @deposito" do
        post :create, {:deposito => valid_attributes}, valid_session
        assigns(:deposito).should be_a(Deposito)
        assigns(:deposito).should be_persisted
      end

      it "redirects to the created deposito" do
        post :create, {:deposito => valid_attributes}, valid_session
        response.should redirect_to(Deposito.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved deposito as @deposito" do
        # Trigger the behavior that occurs when invalid params are submitted
        Deposito.any_instance.stub(:save).and_return(false)
        post :create, {:deposito => { "nombre" => "invalid value" }}, valid_session
        assigns(:deposito).should be_a_new(Deposito)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        Deposito.any_instance.stub(:save).and_return(false)
        post :create, {:deposito => { "nombre" => "invalid value" }}, valid_session
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested deposito" do
        deposito = Deposito.create! valid_attributes
        # Assuming there are no other depositos in the database, this
        # specifies that the Deposito created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        Deposito.any_instance.should_receive(:update).with({ "nombre" => "MyString" })
        put :update, {:id => deposito.to_param, :deposito => { "nombre" => "MyString" }}, valid_session
      end

      it "assigns the requested deposito as @deposito" do
        deposito = Deposito.create! valid_attributes
        put :update, {:id => deposito.to_param, :deposito => valid_attributes}, valid_session
        assigns(:deposito).should eq(deposito)
      end

      it "redirects to the deposito" do
        deposito = Deposito.create! valid_attributes
        put :update, {:id => deposito.to_param, :deposito => valid_attributes}, valid_session
        response.should redirect_to(deposito)
      end
    end

    describe "with invalid params" do
      it "assigns the deposito as @deposito" do
        deposito = Deposito.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Deposito.any_instance.stub(:save).and_return(false)
        put :update, {:id => deposito.to_param, :deposito => { "nombre" => "invalid value" }}, valid_session
        assigns(:deposito).should eq(deposito)
      end

      it "re-renders the 'edit' template" do
        deposito = Deposito.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Deposito.any_instance.stub(:save).and_return(false)
        put :update, {:id => deposito.to_param, :deposito => { "nombre" => "invalid value" }}, valid_session
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested deposito" do
      deposito = Deposito.create! valid_attributes
      expect {
        delete :destroy, {:id => deposito.to_param}, valid_session
      }.to change(Deposito, :count).by(-1)
    end

    it "redirects to the depositos list" do
      deposito = Deposito.create! valid_attributes
      delete :destroy, {:id => deposito.to_param}, valid_session
      response.should redirect_to(depositos_url)
    end
  end

end

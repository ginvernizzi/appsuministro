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

describe ObrasProyectosController do

  # This should return the minimal set of attributes required to create a valid
  # ObraProyecto. As you add validations to ObraProyecto, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) { { "codigo" => "MyString" } }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # ObraProyectosController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  describe "GET index" do
    it "assigns all obras_proyectos as @obras_proyectos" do
      obra_proyecto = ObraProyecto.create! valid_attributes
      get :index, {}, valid_session
      assigns(:obras_proyectos).should eq([obra_proyecto])
    end
  end

  describe "GET show" do
    it "assigns the requested obra_proyecto as @obra_proyecto" do
      obra_proyecto = ObraProyecto.create! valid_attributes
      get :show, {:id => obra_proyecto.to_param}, valid_session
      assigns(:obra_proyecto).should eq(obra_proyecto)
    end
  end

  describe "GET new" do
    it "assigns a new obra_proyecto as @obra_proyecto" do
      get :new, {}, valid_session
      assigns(:obra_proyecto).should be_a_new(ObraProyecto)
    end
  end

  describe "GET edit" do
    it "assigns the requested obra_proyecto as @obra_proyecto" do
      obra_proyecto = ObraProyecto.create! valid_attributes
      get :edit, {:id => obra_proyecto.to_param}, valid_session
      assigns(:obra_proyecto).should eq(obra_proyecto)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new ObraProyecto" do
        expect {
          post :create, {:obra_proyecto => valid_attributes}, valid_session
        }.to change(ObraProyecto, :count).by(1)
      end

      it "assigns a newly created obra_proyecto as @obra_proyecto" do
        post :create, {:obra_proyecto => valid_attributes}, valid_session
        assigns(:obra_proyecto).should be_a(ObraProyecto)
        assigns(:obra_proyecto).should be_persisted
      end

      it "redirects to the created obra_proyecto" do
        post :create, {:obra_proyecto => valid_attributes}, valid_session
        response.should redirect_to(ObraProyecto.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved obra_proyecto as @obra_proyecto" do
        # Trigger the behavior that occurs when invalid params are submitted
        ObraProyecto.any_instance.stub(:save).and_return(false)
        post :create, {:obra_proyecto => { "codigo" => "invalid value" }}, valid_session
        assigns(:obra_proyecto).should be_a_new(ObraProyecto)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        ObraProyecto.any_instance.stub(:save).and_return(false)
        post :create, {:obra_proyecto => { "codigo" => "invalid value" }}, valid_session
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested obra_proyecto" do
        obra_proyecto = ObraProyecto.create! valid_attributes
        # Assuming there are no other obras_proyectos in the database, this
        # specifies that the ObraProyecto created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        ObraProyecto.any_instance.should_receive(:update).with({ "codigo" => "MyString" })
        put :update, {:id => obra_proyecto.to_param, :obra_proyecto => { "codigo" => "MyString" }}, valid_session
      end

      it "assigns the requested obra_proyecto as @obra_proyecto" do
        obra_proyecto = ObraProyecto.create! valid_attributes
        put :update, {:id => obra_proyecto.to_param, :obra_proyecto => valid_attributes}, valid_session
        assigns(:obra_proyecto).should eq(obra_proyecto)
      end

      it "redirects to the obra_proyecto" do
        obra_proyecto = ObraProyecto.create! valid_attributes
        put :update, {:id => obra_proyecto.to_param, :obra_proyecto => valid_attributes}, valid_session
        response.should redirect_to(obra_proyecto)
      end
    end

    describe "with invalid params" do
      it "assigns the obra_proyecto as @obra_proyecto" do
        obra_proyecto = ObraProyecto.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        ObraProyecto.any_instance.stub(:save).and_return(false)
        put :update, {:id => obra_proyecto.to_param, :obra_proyecto => { "codigo" => "invalid value" }}, valid_session
        assigns(:obra_proyecto).should eq(obra_proyecto)
      end

      it "re-renders the 'edit' template" do
        obra_proyecto = ObraProyecto.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        ObraProyecto.any_instance.stub(:save).and_return(false)
        put :update, {:id => obra_proyecto.to_param, :obra_proyecto => { "codigo" => "invalid value" }}, valid_session
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested obra_proyecto" do
      obra_proyecto = ObraProyecto.create! valid_attributes
      expect {
        delete :destroy, {:id => obra_proyecto.to_param}, valid_session
      }.to change(ObraProyecto, :count).by(-1)
    end

    it "redirects to the obras_proyectos list" do
      obra_proyecto = ObraProyecto.create! valid_attributes
      delete :destroy, {:id => obra_proyecto.to_param}, valid_session
      response.should redirect_to(obras_proyectos_url)
    end
  end

end
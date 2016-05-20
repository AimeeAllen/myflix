require 'spec_helper'

describe UsersController do
  describe "GET new" do
    it "assigns @user" do
      get :new
      # new records can not be compared for inequality as they have no PK
      expect(assigns(:user)).to be_new_record
      expect(assigns(:user)).to be_instance_of(User)
    end
  end
  describe "POST create" do
    context "with valid input" do
      before {post :create, user: Fabricate.attributes_for(:user)}
      it "creates the user" do
        expect(User.count).to eq(1)
      end
      it "redirects to login" do
        expect(response).to redirect_to(login_path)
      end
    end
    context "with invalid input" do
      before do
        #note must use key in params hash, and assign key value pairs, can't use an object
        post :create, user: {fullname: "John Smith"}
      end
      it "should not save the user" do
        expect(User.count).to eq(0)
      end
      it "renders new template" do
        expect(response).to render_template(:new)
      end
      it "sets @user" do
        expect(assigns(:user)).to be_new_record
        expect(assigns(:user)).to be_instance_of(User)
        expect(assigns(:user).fullname).to eq("John Smith")
      end
    end
  end
end

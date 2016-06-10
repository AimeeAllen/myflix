require "spec_helper"

describe SessionsController do
  describe "GET new" do
    it "renders new template when not logged in" do
      get :new
      expect(response).to render_template(:new)
    end
    it "redirects to home if user already logged in" do
      session[:user_id] = Fabricate(:user).id
      get :new
      expect(response).to redirect_to(home_path)
    end
  end
  describe "POST create" do
    let(:user1) {Fabricate(:user)}
    context "valid login" do
      before do
        post :create, email: user1.email, password: user1.password
      end
      it "finds a user with the provided email" do
        expect(assigns(:user)).to eq(user1)
      end
      it "authenticates the provided password" do
        expect(assigns(:user).authenticate(user1.password)).to be_truthy
      end
      it "puts the signed in user in the session" do
        expect(session[:user_id]).to eq(user1.id)
      end
      it "redirects to home" do
        expect(response).to redirect_to(home_path)
      end
      it "sets success message" do
        expect(flash[:success]).to be_truthy
      end
    end
    context "invalid login" do
      before do
        post :create, email: user1.email, password: user1.password + "junk"
      end
      it "does not put the user in the session" do
        expect(session[:user_id]).to be_nil
      end
      it "renders the new template" do
        expect(response).to render_template(:new)
      end
      it "sets error message" do
        expect(flash[:danger]).not_to be_blank
      end
    end
  end
  describe "GET destroy" do
    before do
      session[:user_id] = Fabricate(:user).id
      get :destroy
    end
    it "erases the user_id in the session" do
      expect(session[:user_id]).to be_falsey
    end
    it "redirects to root" do
      expect(response).to redirect_to(root_path)
    end
    it "sets flash message" do
      expect(flash[:success]).to be_truthy
    end
  end
end

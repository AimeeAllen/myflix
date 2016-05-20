require 'spec_helper'

describe CategoriesController do
  describe "GET show" do
    let(:category) {Fabricate(:category)}
    it "sets the @category variable if user is authenticated" do
      session[:user_id] = Fabricate(:user).id
      get :show, id: category
      expect(assigns(:category)).to eq(category)
    end
    it "redirects to login if user is not authenticated" do
      get :show, id: category
      expect(response).to redirect_to(login_path)
    end
  end
end
require 'spec_helper'

describe CategoriesController do
  describe "GET show" do
    let(:category) {Fabricate(:category)}
    it "sets the @category variable if user is authenticated" do
      session[:user_id] = Fabricate(:user).id
      get :show, id: category
      expect(assigns(:category)).to eq(category)
    end
    it_behaves_like "no logged in user" do
      let(:action) {get :show, id: category}
    end
  end
end
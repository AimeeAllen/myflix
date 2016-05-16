require 'spec_helper'

describe VideosController  do
  describe "GET show" do
    let (:video) {Fabricate(:video)}
    it "sets the @video variable if user is authenticated" do
      session[:user_id] = Fabricate(:user).id
      get :show, id: video.id
      expect(assigns(:video)).to eq(video)
    end
    it "redirects to login page if user is not authenticated" do
      get :show, id: video.id
      expect(response).to redirect_to("/login")
    end
  end
  describe "GET search" do
    context "with authenticated users" do
      before do
        session[:user_id] = Fabricate(:user).id
      end
      it "sets the @videos variable" do
        # overkill to have multiple videos here as this was already tested in model
        futurama = Fabricate(:video, title: "Futurama")
        get :search, search_term: "futur"
        expect(assigns(:videos)).to match_array([futurama])
      end
    end
    context "with unauthenticated users" do
      it "redirects to login page" do
        get :search, search_term: "anything"
        expect(response).to redirect_to(login_path)
      end
    end
  end
end

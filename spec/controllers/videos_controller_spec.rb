require 'spec_helper'

describe VideosController  do
  describe "GET show" do
    let (:video) {Fabricate(:video)}
    context "user is authenticated" do
      before do
        session[:user_id] = Fabricate(:user).id
        get :show, id: video.id
      end
      it "sets the @video variable" do
        expect(assigns(:video)).to eq(video)
      end
      it "sets the @reviews variable" do
        reviews = []
        3.times {reviews.push Fabricate(:review, video: video)}
        expect(assigns(:reviews)).to match_array(reviews)
      end
      it "sets the @review variable" do
        expect(assigns(:review)).to be_new_record
        expect(assigns(:review)).to be_instance_of(Review)
      end
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
        expect(assigns(:videos)).to include(futurama)
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

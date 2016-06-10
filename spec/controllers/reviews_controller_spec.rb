require 'spec_helper'

describe ReviewsController do
  describe "POST create" do
    context "authenticated user" do
      let(:user) {Fabricate(:user)}
      let(:video) {Fabricate(:video)}
      before do
        session[:user_id] = user.id
      end
      context "valid review" do
        before do
          # Note: must use video_id (not just video) to refer to parent object on nested resources
          post :create, video_id: video, review: Fabricate.attributes_for(:review, user: user, video: video)
        end
        it "has the correct video association" do
          expect(assigns(:review).video).to eq(video)
        end
        it "has the correct user assocation" do
          expect(assigns(:review).user).to eq(user)
        end
        it "saves the review" do
          expect(assigns(:review)).not_to be_new_record
        end
        it "displays a success message" do
          expect(flash[:success]).not_to be_blank
        end
        it "redirects to the video show page" do
          expect(response).to redirect_to(video_path(video))
        end
      end
      context "invalid review" do
        before do
          post :create, video_id: video.id, review: Fabricate.attributes_for(:review, comment: "", user: user, video: video)
        end
        it "renders video show" do
          expect(response).to render_template("videos/show")
        end
        it "displays the errors on the form" do
          expect(flash[:danger]).not_to be_blank
        end
        it "doesn't save the review" do
          expect(assigns(:review)).to be_new_record
        end
      end
    end
    it "redirects to home for an unauthenticated user" do
      post :create, video_id: Fabricate(:video).id, review: Fabricate.attributes_for(:review)
      expect(response).to redirect_to(login_path)
    end
  end
end

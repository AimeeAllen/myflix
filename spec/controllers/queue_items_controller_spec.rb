require 'spec_helper'

describe QueueItemsController do
  describe "GET index" do
    context "authenticated user" do
      let(:logged_in_user) {Fabricate(:user)}
      before do
        session[:user_id] = logged_in_user.id
      end
      it "sets @queue_items" do
        queue = []
        3.times {queue << Fabricate(:queue_item, user: logged_in_user)}
        get :index
        expect(assigns(:queue_items)).to match_array(queue)
      end
      it "has @queue_items only contain items for the signed in user" do
        queue = []
        another_user = Fabricate(:user)
        3.times {queue << Fabricate(:queue_item, user: logged_in_user)}
        Fabricate(:queue_item, user: another_user)
        get :index
        expect(assigns(:queue_items)).to match_array(queue)
      end
      it "sets @queue_items to an empty array if there are no items in the queue" do
        another_user = Fabricate(:user)
        Fabricate(:queue_item, user: another_user)
        get :index
        expect(assigns(:queue_items)).to eq([])
      end
    end
    it "redirects to login if there is no current user" do
      get :index
      expect(response).to redirect_to(:login)
    end
  end

  describe "POST create" do
    context "authenticated user" do
      let(:logged_in_user) {Fabricate(:user)}
      let(:video) {Fabricate(:video)}
      before do
        session[:user_id] = logged_in_user.id
      end
      it "saves a new queue_item" do
        post :create, video_id: video.id
        expect(QueueItem.count).to eq(1)
      end
      it "has the new queue item attached to the current user" do
        post :create, video_id: video.id
        expect(QueueItem.first.user_id).to eq(logged_in_user.id)
      end
      it "has the new queue item attached to the video the user was looking at" do
        post :create, video_id: video.id
        expect(QueueItem.first.video_id).to eq(video.id)
      end
      it "assigns an order to be the last number in the queue" do
        2.times {Fabricate(:queue_item, user: logged_in_user)}
        post :create, video_id: video.id
        expect(QueueItem.last.order).to eq(logged_in_user.queue_items.size)
      end
      it "doesn't add the video to the queue if it is already in the queue" do
        Fabricate(:queue_item, user: logged_in_user, video: video)
        post :create, video_id: video.id
        expect(QueueItem.where(user_id: logged_in_user.id, video_id: video.id).size).to eq(1)
      end
      it "redirects to my_queue" do
        post :create, video_id: video.id
        expect(response).to redirect_to(:my_queue)
      end
    end
    it "redirects to login if there is no current user" do
      post :create
      expect(response).to redirect_to(:login)
    end
  end
end

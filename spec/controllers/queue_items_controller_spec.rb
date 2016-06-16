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

  describe "POST destroy" do
    context "authenticated user" do
      let(:logged_in_user) {Fabricate(:user)}
      before do
        session[:user_id] = logged_in_user.id
      end
      it "redirects back to my_queue" do
        queue_item = Fabricate(:queue_item, user: logged_in_user)
        delete :destroy, id: queue_item.id
        expect(response).to redirect_to(:my_queue)
      end
      it "soft deletes the queue item by setting the deleted flag" do
        queue_item = Fabricate(:queue_item, user: logged_in_user)
        delete :destroy, id: queue_item.id
        expect(queue_item.reload.deleted).to be true
      end
      it "only deletes a queue item if the item is associated with the logged in user" do
        queue_item = Fabricate(:queue_item)
        delete :destroy, id: queue_item.id
        expect(queue_item.reload.deleted).to be false
      end
      it "displays a message that the video was removed from queue" do
        queue_item = Fabricate(:queue_item, user: logged_in_user)
        delete :destroy, id: queue_item.id
        expect(flash[:success]).not_to be_blank
      end
      it "changes the order number on all later queue items" do
        3.times {post :create, video_id: Fabricate(:video).id}
        delete :destroy, id: QueueItem.second.id
        expect(QueueItem.first.order).to eq(1)
        expect(QueueItem.third.order).to eq(2)
      end
    end
    context "no user logged in" do
      let(:queue_item) {Fabricate(:queue_item)}
      it "redirects to login" do
        delete :destroy, id: queue_item.id
        expect(response).to redirect_to(:login)
      end
      it "doesn't destroy the queue item" do
        delete :destroy, id: queue_item.id
        expect(queue_item.deleted).to be false
      end
    end
  end

  describe "POST update_queue" do
    context "logged in user" do
      let(:logged_in_user) {Fabricate(:user)}
      let(:queue_item1) {Fabricate(:queue_item, user: logged_in_user, order: 1)}
      let(:queue_item2) {Fabricate(:queue_item, user: logged_in_user, order: 2)}
      before do
        session[:user_id] = logged_in_user.id
      end
      context "all queue items are valid" do
        it "redirects to my_queue" do
          post :update_queue, queue_items: [{id: queue_item1.id, order: 2}, {id: queue_item2.id, order: 1}]
          expect(response).to redirect_to(:my_queue)
        end
        it "re-orders every queue item, from lowest order to highest" do
          post :update_queue, queue_items: [{id: queue_item1.id, order: 5}, {id: queue_item2.id, order: 3}]
          expect(logged_in_user.queue_items).to eq([queue_item2, queue_item1])
        end
        it "normalises the orders so they are sequential integers from 1" do
          post :update_queue, queue_items: [{id: queue_item1.id, order: 5}, {id: queue_item2.id, order: 3}]
          expect(logged_in_user.queue_items.map(&:order)).to eq([1,2])
        end
        it "displays a success message" do
          post :update_queue, queue_items: [{id: queue_item1.id, order: 2}, {id: queue_item2.id, order: 1}]
          expect(flash[:success]).not_to be_blank
        end
      end
      context "one or more queue items in invalid" do
        before {post :update_queue, queue_items: [{id: queue_item1.id, order: 2}, {id: queue_item2.id, order: 1.784}]}
        it "redirects to my_queue" do
          expect(response).to redirect_to(:my_queue)
        end
        it "does not update any queue items" do
          expect(queue_item1.reload.order).to eq(1)
          expect(queue_item2.reload.order).to eq(2)
        end
        it "displays error message" do
          expect(flash[:danger]).to be_present
        end
      end
      context "queue items which don't belong to logged in user" do
        it "only updates queue_items which belong to the logged in user" do
          other_user = Fabricate(:user)
          queue_item3 = Fabricate(:queue_item, user: other_user, order: 3)
          post :update_queue, queue_items: [{id: queue_item2.id, order: 4}, {id: queue_item3.id, order: 1}]
          expect(queue_item3.reload.order).to eq(3)
        end
      end
    end
    it "redirects to sign in with no logged in user" do
      post "update_queue", queue_items: [{id: 34, order: 3}, {id: 12, order: 1}]
      expect(response).to redirect_to(:login)
    end
  end
end

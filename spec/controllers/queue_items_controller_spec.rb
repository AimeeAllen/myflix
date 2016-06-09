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
end

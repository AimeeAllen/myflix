require 'spec_helper'

describe User do
  it {should have_many(:reviews)}
  it {should have_many(:queue_items).order('"order"')}
  it {should have_many(:videos).through(:queue_items)}
  it "should only associate to non-deleted queue_items" do
    user = Fabricate(:user)
    active_queue_item = Fabricate(:queue_item, user: user)
    deleted_queue_item = Fabricate(:queue_item, user: user, deleted: true)
    expect(user.queue_items).to match_array([active_queue_item])
  end

  describe ".normalise_queue_item_orders" do
    it "should re-number the queue order such that they are sequential integers from 1" do
      user = Fabricate(:user)
      4.times {user.queue_items << Fabricate(:queue_item, user: user)}
      user.normalise_queue_item_orders
      expect(user.queue_items.map(&:order)).to eq([1,2,3,4])
    end
  end

  describe ".queued_video?(video)" do
    let(:user) {Fabricate(:user)}
    let(:video) {Fabricate(:video)}
    it "returns true if the passed in video belongs to the user's queue" do
      Fabricate(:queue_item, user: user, video: video)
      expect(user.queued_video?(video)).to be true
    end
    it "returns false if the passed in video doesn't below to the user's queue" do
      expect(user.queued_video?(video)).to be false
    end
  end
end

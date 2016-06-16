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
end

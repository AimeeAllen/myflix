require 'spec_helper'

describe QueueItem do
  it {should belong_to(:user)}
  it {should belong_to(:video)}
  it {should validate_presence_of(:user)}
  it {should validate_presence_of(:video)}
  #it {should have_one(:category), through: :video}
  describe ".category" do
    it "should display the category of the associated video" do
      video = Fabricate(:video)
      queue_item = Fabricate(:queue_item, video: video)
      expect(queue_item.category).to eq(video.category)
    end
  end

  describe ".cateogry_name" do
    it "returns the category name for the associated video" do
      video = Fabricate(:video)
      queue_item = Fabricate(:queue_item, video: video)
      expect(queue_item.category_name).to eq(video.category.label)
    end
  end

  describe ".rating" do
    let(:user) {Fabricate(:user)}
    let(:video) {Fabricate(:video)}
    let(:queue_item) {Fabricate(:queue_item, video: video, user: user)}
    it "should return the rating the associated user has given the associated video" do
      review = Fabricate(:review, video: video, user: user)
      expect(queue_item.rating).to eq(review.rating)
    end
    it "should return 0 if no rating has been given" do
      expect(queue_item.rating).to eq(0)
    end
  end
end

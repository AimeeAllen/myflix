require 'spec_helper'

describe Review do
  it {should belong_to(:user)}
  it {should belong_to(:video)}
  it {should validate_presence_of(:comment)}
  it {should validate_presence_of(:rating)}
  it {should validate_presence_of(:user)}
  it {should validate_uniqueness_of(:user_id).scoped_to(:video_id)}

  let(:review) {Fabricate(:review)}

  it "should have an integer rating" do
    expect(review.rating).to be_kind_of(Integer)
  end
  it "should have a rating between 1 and 5" do
    expect(review.rating).to be_between(1,5)
  end
end

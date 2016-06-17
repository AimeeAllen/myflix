require 'spec_helper'

describe Video do
  # it "saves itself" do
  #   video = Video.new(title: "The Lion King", description: "A roaringly good film")
  #   video.save
  #   expect(Video.first).to eq(video)
  # end

  it {should belong_to(:category)}
  # it "belongs to a Category" do
  #   educational = Category.create(label: "Educational")
  #   tealeaf = Video.create(title: "Tealeaf course", description: "Rails training", category: educational)
  #   expect(tealeaf.category).to eq(educational)
  # end

  it {should validate_presence_of(:title)}
  # it "must have a title to save" do
  #   video = Video.new(description: "I have no title")
  #   expect(video.save).to eq(false)
  # end

  it {should validate_presence_of(:description)}
  # it "must have a description to save" do
  #   video = Video.create(title: "No description")
  #   expect(Video.count).to eq(0)
  # end

  it {should have_many(:reviews)}
  it {should have_many(:queue_items)}
  it {should have_many(:users).through(:queue_items)}

  describe ".search_by_title" do
    # before(:each) do
    #   video1 = Video.create(title: 'string', description: "anything")
    #   video2 = Video.create(title: 'some string', description: "anything")
    #   video3 = Video.create(title: 'other strings here', description: "anything")
    # end
    it "returns an empty array if no matches are found" do
      video1 = Video.create(title: 'string', description: "anything")
      expect(Video.search_by_title('hello')).to eq([])
    end
    it "returns an array with one element if only one exact match is found" do
      video1 = Video.create(title: 'string', description: "anything")
      video2 = Video.create(title: 'some string', description: "anything")    
      expect(Video.search_by_title('some string')).to eq([video2])
    end
    it "matches part titles" do
      video1 = Video.create(title: 'string', description: "anything")
      video2 = Video.create(title: 'some string', description: "anything")
      video3 = Video.create(title: 'other strings here', description: "anything")
      expect(Video.search_by_title('string')).to match_array([video1, video2, video3])
    end
    it "returns an array of all matches ordered by created_at DESC" do
      video1 = Video.create(title: 'string', description: "anything")
      video2 = Video.create(title: 'some string', description: "anything")
      video3 = Video.create(title: 'other strings here', description: "anything")
      expect(Video.search_by_title('string')).to eq([video3,video2,video1])
    end
    it "to be case insensitive" do
      video1 = Video.create(title: 'string', description: "anything")
      video2 = Video.create(title: 'some string', description: "anything")
      video3 = Video.create(title: 'other strings here', description: "anything")
      video4 = Video.create(title: 'mESsy STRing', description: "anything")
      expect(Video.search_by_title('stRing')).to match_array([video1,video2,video3,video4])
    end
    it "returns an empty array if the search input is an empty string" do
      video1 = Video.create(title: 'string', description: "anything")
      video2 = Video.create(title: 'some string', description: "anything")
      video3 = Video.create(title: 'other strings here', description: "anything")
      expect(Video.search_by_title("")).to eq([])
    end
    # after(:each) do
    #   Video.all.each {|e| e.delete}
    # end
  end

  describe ".average_rating" do
    let(:video) {Fabricate(:video)}
    it "calculates average of all ratings to 1 d.p." do
      videos = []
      45.times {videos.push (Fabricate(:review, video: video))}
      expect(video.average_rating).to eq(((videos.map {|v| v.rating}).reduce(:+).to_f/videos.size).round(1))
    end
    it "returns 0 if there are no ratings" do
      expect(video.average_rating).to eq(0)
    end
    it "returns the one rating when there is only one" do
      review = Fabricate(:review, video: video)
      expect(video.average_rating).to eq(video.reviews.first.rating)
    end
  end

  describe ".recent_reviews" do
    let(:video) {Fabricate(:video)}
    it "returns reviews in an array" do
      review1 = Fabricate(:review, video: video)
      review2 = Fabricate(:review, video: video)
      expect(video.recent_reviews).to match_array([review1, review2])
    end
    it "returns an empty array if there are no reviews" do
      expect(video.recent_reviews).to eq([])
    end
    it "has reviews in reverse chronological order" do
      review1 = Fabricate(:review, video: video, created_at: 1.day.ago)
      review2 = Fabricate(:review, video: video)
      expect(video.recent_reviews).to eq([review2, review1])
    end
    it "only shows up to 8 reviews" do
      videos = []
      10.times {videos.push (Fabricate(:review, video: video))}
      expect(video.recent_reviews).to eq(videos.last(8).reverse)
    end
  end

end
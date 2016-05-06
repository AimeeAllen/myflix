require 'spec_helper'

describe Category do
  #NEVER Test internal functionality of third party gems, only test your team's code
  # it "saves itself" do
  #   category = Category.new(label: "Educational")
  #   category.save
  #   expect(Category.first).to eq(category)
  # end

  it {should have_many(:videos)}
  # it "has many Videos" do
  #   educational = Category.create(label: "Educational")
  #   tealeaf = Video.create(title: "Tealeaf course", description: "Rails training", category: educational)
  #   c_sharp = Video.create(title: "Learn C#", description: "Work for a Microsoft partner", category: educational)
  #   expect(educational.videos).to match_array([tealeaf,c_sharp])    
  # end

  describe ".recent_videos" do
    it "returns an empty array if no videos are in the category" do
      category = Category.create(label: "This category")
      expect(category.recent_videos).to eq([])
    end
    it "returns an array of videos in the category" do
      category = Category.create(label: "This category")
      videos =[]
      3.times {videos << Video.create(title: "Title", description: "Here is my description", category: category)}
      expect(category.recent_videos).to match_array(videos)
    end
    it "returns videos ordered by most recent created_at first" do
      category = Category.create(label: "This category")
      video1 = Video.create(title: "Title1", description: "Here is first description", category: category, created_at: 2.days.ago)
      video2 = Video.create(title: "Title2", description: "Here is second description", category: category, created_at: 1.day.ago)
      video3 = Video.create(title: "Title3", description: "Here is third description", category: category)
      expect(category.recent_videos).to eq([video3, video2, video1])
    end
    it "only returns the 6 most recent videos" do
      category = Category.create(label: "This category")
      videos = []
      12.times {videos << Video.create(title: "Title", description: "Here is my description", category: category)}
      expect(category.recent_videos).to eq(videos.last(6).reverse)
    end
    it "returns all the videos of a category if there are less than 6" do
      category = Category.create(label: "This category")
      videos =[]
      5.times {videos << Video.create(title: "Title", description: "Here is my description", category: category)}
      expect(category.recent_videos.count).to eq(5)
    end
  end
end
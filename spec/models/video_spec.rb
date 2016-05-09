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
end
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
end
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
end
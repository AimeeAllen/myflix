Fabricator(:review) do  
  comment (Faker::Lorem.paragraph)
  rating (Faker::Number.between(1,5))
  video
  user # tells it to fabricate a user to connect to
end

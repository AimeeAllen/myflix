Fabricator(:queue_item) do
  video
  user
  order {Faker::Number.digit}
end

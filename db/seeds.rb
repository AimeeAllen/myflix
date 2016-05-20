# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

categories = Category.create([{label: 'TV Commedies'}, 
  {label: 'TV Dramas'},
  {label: 'Reality TV'}])

videos = Video.create([{title: 'Family Guy', description: 'Adult cartoon',
    small_cover_url: '/tmp/family_guy.jpg', large_cover_url: '/tmp/family_guy.jpg',
    category: Category.find_by({label: 'TV Commedies'})},
  {title: 'Futurama', description: 'Pizza boy Philip J. Fry awakens in the 31st century ' +
    'after 1,000 years of cryogenic preservation in this animated series. ' +
    'After he gets a job at an interplanetary delivery service, ' +
    'Fry embarks on ridiculous escapades to make sense of his predicament.',
    small_cover_url: '/tmp/futurama.jpg', large_cover_url: '/tmp/futurama.jpg',
    category: Category.find_by({label: 'TV Commedies'})},
  {title: 'Monk', description: 'TBA',
    small_cover_url: '/tmp/monk.jpg', large_cover_url: '/tmp/monk_large.jpg',
    category: Category.find_by({label: 'TV Dramas'})},
  {title: 'South Park', description: 'Potty humour cartoon',
    small_cover_url: '/tmp/south_park.jpg', large_cover_url: '/tmp/south_park.jpg',
    category: Category.find_by({label: 'TV Commedies'})}])

users = User.create([{fullname: "User1", email: "user1@email.com", password: "test"},
    {fullname: "User2", email: "user2@email.com", password: "test"}])

reviews = Review.create([{comment: "This is a good show", rating: "4", user: users[0], video: videos[1]},
    {comment: "This is a bad show", rating: "1", user: users[1], video: videos[1]},
    {comment: "This is a good show", rating: "4", user: users[1], video: videos[3]}])



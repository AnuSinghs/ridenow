# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

require 'faker'
require "open-uri"

puts 'destroy old data'

User.destroy_all
Listing.destroy_all
Category.destroy_all

3.times do
  user = User.new(
    username: Faker::Name.unique.name,
    email: Faker::Internet.email,
    address:Faker::Address.full_address,
    password:Faker::Alphanumeric.alphanumeric(number: 8)
    )
  puts "creating user: #{user.username}"
  fileav = URI.open(Faker::Avatar.image)
  user.avatar.attach(io: fileav, filename: "#{user.username}.png", content_type: 'image/png')
  user.save!
end

5.times do
    category = Category.new(
    name: ["Hawker Centre", "Historic Sights", "Kid Friendly", "Halal Certified"].sample
    )
    puts "creating category: #{category.name}"
    category.save!
end

5.times do
  listing = Listing.new(
    address: ["920 ECP, Singapore", "902 E Coast Park Service Rd, Singapore", "208 E Coast Rd, Singapore", "6 Chapel Rd, Singapore", "920 East Coast Parkway, Singapore", "63 E Coast Rd, Singapore", "318A Joo Chiat Rd, Singapore", "10 Bayfront Ave, Singapore", "18 Marina Gardens Dr, Singapore", "1 Fullerton Rd, Singapore", "30 Raffles Ave, Singapore", "1 Cluny Rd, Singapore", "6 Bayfront Ave, Singapore", "93 Stamford Rd, Singapore", "31 Mugliston Rd, Singapore", "287 Joo Chiat Rd, Singapore", "83 Marine Parade Central, Singapore", "122 Ceylon Rd, Singapore"].sample,
    rating: (1..5).to_a.sample,
    )
  file = URI.open("https://source.unsplash.com/400x300/?restaurants")
  listing.photo.attach(io: file, filename: "#{listing.id}.png", content_type: 'image/png')
  listing.save!
  puts "creating listing: #{listing.address}"
  listing.categories << Category.all.sample
end

puts "Seed done!"







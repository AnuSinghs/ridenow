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
    listing = Listing.new(
      address: ["Spinach", "Carrots", "Broccoli", "Brussels Sprouts", "Green Peas", "Ginger", "Asparagus", "Cabbage", "Potatoes", "Turnip", "Capsicum", "Eggplant", "Bok Choy", "Radish", "Onion", "Celery", "Lettuce", "Artichoke", "Cauliflower","Avocado", "Cucumber"].sample,
      rating: (1..5).to_a.sample,
    )
  puts "creating listing: #{listing.id}"
  file = URI.open("https://source.unsplash.com/400x300/?restaurants")
  listing.photo.attach(io: file, filename: "#{listing.title}.png", content_type: 'image/png')
  listing.save!
  end

  5.times do
    category = Category.new(
    name: ["Spinach", "Carrots", "Broccoli", "Brussels Sprouts", "Green Peas", "Ginger", "Asparagus", "Cabbage", "Potatoes", "Turnip", "Capsicum", "Eggplant", "Bok Choy", "Radish", "Onion", "Celery", "Lettuce", "Artichoke", "Cauliflower","Avocado", "Cucumber"].sample,
    )
  puts "creating listing: #{category.name}"
  category.save!
  end

  5.times do
    category_listing = Category_listings.new(
      category: ,
      listing:
      )
  category_listing.save!
  end



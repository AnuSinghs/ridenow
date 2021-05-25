# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

require 'faker'
require "open-uri"
require 'csv'
require 'resolv-replace'

puts 'destroy old data'

  User.destroy_all
  Tag.destroy_all
  Category.destroy_all

 # 3.times do
 #  user = User.new(
 #    username: Faker::Name.unique.name,
 #    email: Faker::Internet.email,
 #    address:Faker::Address.full_address,
 #    password:Faker::Alphanumeric.alphanumeric(number: 8)
 #   )
 #   puts "creating user: #{user.username}"
 #   fileav = URI.open(Faker::Avatar.image)
 #   user.avatar.attach(io: fileav, filename: "#{user.username}.png", content_type: 'image/png')
 #   user.save!
 # end

Category.create(name: "Sights")
Category.create(name: "Eats")

Tag.create(name: "Monuments")
Tag.create(name: "Museums")
Tag.create(name: "Parks")
Tag.create(name: "Bakeries")
Tag.create(name: "Fastfood")
Tag.create(name: "Restaurants")
Tag.create(name: "Beverages")
Tag.create(name: "Cafés")
Tag.create(name: "Supermarkets")



 csv_options = { col_sep: ',', quote_char: '"', headers: :first_row }
 filepath = File.join(__dir__, "listingseeds.csv")

   CSV.foreach(filepath, csv_options) do |row|
    l = Listing.new
    l.name = row['Name']
    l.description = row['Description']
    l.address =  row['House'].blank? ? row['Address'] : "#{row['House']} #{row['Address']}"
    l.rating = (1..5).to_a.sample
    l.latitude = row['Latitude']
    l.longitude = row['Longitude']
    l.category = Category.find_by_name(row['Category'])
    l.tags << Tag.find_by_name(row['Tags'])
    l.save!
    puts "creating listing: #{l.name}-#{row['Tags']}"
 end

puts "Seed done!"






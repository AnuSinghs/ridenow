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
require 'pry-byebug'

puts 'destroy old data'

User.destroy_all
Tag.destroy_all
Listing.destroy_all
Category.destroy_all


# 3.times do
#   user = User.new(
#     username: Faker::Name.unique.name,
#     email: Faker::Internet.email,
#     address:Faker::Address.full_address,
#     password:Faker::Alphanumeric.alphanumeric(number: 8)
#     )
#   puts "creating user: #{user.username}"
#   fileav = URI.open(Faker::Avatar.image)
#   user.avatar.attach(io: fileav, filename: "#{user.username}.png", content_type: 'image/png')
#   user.save!
# end

3.times do
  tag = Tag.new(
    name: ["Park", "Historic", "Popular", "Top Rated"].sample
    )
  puts "creating tag: #{tag.name}"
  tag.save!
end

Category.create(name: "Sights")
Category.create(name: "Eats")

csv_options = { col_sep: ',', quote_char: '"', headers: :first_row }
filepath = File.join(__dir__, "seeds.csv")

CSV.foreach(filepath, csv_options) do |row|
  l = Listing.new
  l.name = row['Name']
  l.description = Faker::Lorem.paragraph(sentence_count: 2, supplemental: false, random_sentences_to_add: 4)
  l.address = row['Address']
  l.rating = (1..5).to_a.sample
  l.category = Category.find_by_name(row['Category'])
  l.tags << Tag.all.sample
  file = URI.open("https://source.unsplash.com/400x300/?#{l.name}")
  l.photo.attach(io: file, filename: "#{l.name}.png", content_type: 'image/png')
  l.save!
  puts "creating listing: #{l.address}"
end

puts "Seed done!"







# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

ApplicationRecord.transaction do
  puts "Destroying tables..."
  Note.destroy_all
  Track.destroy_all
  Album.destroy_all
  Band.destroy_all
  User.destroy_all

  puts "Resetting primary keys..."
  %w(users bands albums tracks notes).each do |table_name|
    ApplicationRecord.connection.reset_pk_sequence!(table_name)
  end

  puts "Creating users..."
  # 2.times do 
  #   User.create!(
  #     email: Faker::Internet.unique.email,
  #     password: Faker::Internet.password(min_length: 6, max_length:  12),
  #     admin: true,
  #     activated: true
  #   )
  # end

  10.times do 
    User.create!(
      email: Faker::Internet.unique.email,
      password: Faker::Internet.password(min_length: 6, max_length:  12),
      activated: true
    )
  end

  puts "Creating bands..."
  10.times do
    Band.create!(name: Faker::Music.unique.band)
  end

  puts "Creating albums..."
  Band.all.each do |band|
    3.times do
      Album.create!(
        band: band,
        title: Faker::Music.unique.album,
        year: Faker::Number.between(from: 1960, to: 2022) 
      )
    end
  end
  
  puts "Creating tracks..."
  Album.all.each do |album|
    10.times do |i|
      Track.create!(
        album: album,
        title: Faker::Music::RockBand.song,
        ord: i+1,
        lyrics: "#{Faker::Lorem.sentence(word_count: 4)}\n" \
                "#{Faker::Lorem.sentence(word_count: 4)}\n" \
                "#{Faker::Lorem.sentence(word_count: 4)}\n" \
                "#{Faker::Lorem.sentence(word_count: 4)}"
      )
    end
  end

  puts "Creating notes..."
  Track.all.each do |track|
    2.times do
      Note.create!(
        track: track,
        author: User.all.sample,
        content: Faker::Quote.jack_handey 
      )
    end
  end

  puts "Done!"
end
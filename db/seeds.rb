# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

puts 'Creating users...'
users = [
  { email: 'alice@example.com', points_balance: 1000 },
  { email: 'bob@example.com', points_balance: 500 },
  { email: 'charlie@example.com', points_balance: 2000 }
].map { |attrs| User.create!(attrs) }

puts 'Creating rewards...'
rewards = [
  { name: 'Free Coffee', description: 'One free coffee at any location', points_cost: 100, is_active: true },
  { name: '$10 Gift Card', description: '$10 gift card for any store', points_cost: 500, is_active: true },
  { name: 'Movie Ticket', description: 'One free movie ticket', points_cost: 300, is_active: true },
  { name: 'Exclusive Event', description: 'Access to an exclusive event', points_cost: 1500, is_active: false }
].map { |attrs| Reward.create!(attrs) }

puts 'Creating redemptions...'
redemptions = [
  { user: users[0], reward: rewards[0], status: 'completed' },
  { user: users[0], reward: rewards[1], status: 'pending' },
  { user: users[1], reward: rewards[0], status: 'pending' },
  { user: users[2], reward: rewards[2], status: 'cancelled' }
].map { |attrs| Redemption.create!(attrs) }

puts 'Seed data created successfully!'

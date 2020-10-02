# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

5.times do |n|
  User.create!(
    name: "りょうた#{n + 1}",
    email: "onuma-ryota#{n + 1}@gmail.com",
    password_digest: "password#{n + 1}",
    introduction: 'こんにちはー',
    permission: true,
    admin: true
  )
end
43.times do |n|
  Task.create!(
    title: "タスク#{n + 1}",
    content: 'ああああああ',
    status: 1,
    deadline: DateTime.now,
    important: rand(1..3),
    user_id: rand(1..3)
  )
end

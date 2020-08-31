FactoryBot.define do
  factory :user, class: 'User' do
    name { Faker::JapaneseMedia::DragonBall.character }
    email { Faker::Internet.email }
    password_digest { 'password' }
    image { 'https://stat.ameba.jp/user_images/20191108/21/hanakoko-info/3a/db/j/o0602080014634893674.jpg?caw=800' }
    introduction { Faker::ChuckNorris.fact }
    permission { true }
    admin { false }

    trait :banned_user do
      permission { false }
    end

    trait :admin_user do
      admin { true }
    end
  end
end

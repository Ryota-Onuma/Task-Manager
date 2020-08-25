





FactoryBot.define do
  factory :user1 ,class: User do
    name { Faker::JapaneseMedia::DragonBall.character }
    email { Faker::Internet.email }
    password_digest { "password" }
    image { 'https://stat.ameba.jp/user_images/20191108/21/hanakoko-info/3a/db/j/o0602080014634893674.jpg?caw=800' }
    introduction  { Faker::ChuckNorris.fact  }
    permission { true }
    admin { true }
  end

  factory :user2, class: User do
    name { Faker::JapaneseMedia::DragonBall.character }
    email { Faker::Internet.email }
    password_digest { "password" }
    image { 'https://stat.ameba.jp/user_images/20191108/21/hanakoko-info/3a/db/j/o0602080014634893674.jpg?caw=800' }
    introduction  { Faker::ChuckNorris.fact  }
    permission { true }
    admin { false }
  end

end

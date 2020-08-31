require 'date'
FactoryBot.define do
  factory :task do
    title { create_task_title }
    content { Faker::Quotes::Shakespeare.as_you_like_it_quote }
    status { 1 }
    deadline { DateTime.now }
    important { false }

    trait :important do # 重要なtask
      important { true }
    end

    trait :by_admin do # Adminによる投稿
      association :user, factory: :user, admin: true
    end
  end
end

def create_task_title
  content = ''
  3.times do
    content << Faker::Games::Pokemon.name + ' , '
  end
  content
end

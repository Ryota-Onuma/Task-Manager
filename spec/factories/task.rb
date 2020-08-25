require 'date'
FactoryBot.define do
  factory :task do
    title { create_task_title }
    content { Faker::Quotes::Shakespeare.as_you_like_it_quote }
    status { 1 }
    deadline { DateTime.now }
    important { false }
    user_id { 1 }
  end
end

def create_task_title
  (1..3).map { |_i| Faker::Games::Pokemon.name }.join(', ')
end
